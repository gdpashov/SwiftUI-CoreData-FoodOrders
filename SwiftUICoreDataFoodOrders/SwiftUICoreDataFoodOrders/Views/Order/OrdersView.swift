//
//  OrdersView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 1.03.23.
//

import SwiftUI

struct OrdersView: View {
    private static let newOrderLabel: String = "New"
    
    @State private var food: Food?
    
    @State private var _searchText: String = ""
    @State private var layout = BrowserLayout.grid
    @State private var orderFilter = OrderFilter.uncompleted
    
    typealias FoodProperties = (food: FetchedResults<Food>.Element, flavorMaxIntensity: Flavor?)
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Order.statusDate, ascending: true)],
        predicate: NSPredicate(format: "isFinal == true AND statusCode != %@", Order.Status.completed.rawValue),
        animation: .default)
    var fetchedOrders: FetchedResults<Order>
    
    var searchText: Binding<String> {
        Binding {
            _searchText
        } set: { newValue in
            _searchText = newValue
            // Do not change predicate
        }
    }
    
    var body: some View {
        ZStack {
            if layout == .grid {
                grid
            } else {
                list
            }
        }
        .navigationTitle("Orders")
        .searchable(text: searchText)
        .background()
        #if os(iOS)
        .toolbarRole(.browser)
        #endif
        .toolbar {
            ToolbarItemGroup {
                toolbarItems
            }
        }
        .navigationDestination(for: String.self) { newValue in
            switch newValue {
            case OrdersView.newOrderLabel:
                let order = Order.newOrder(viewContext: viewContext, food: nil)
                OrderEditView(order: order)
            default:
                EmptyView()
            }
        }
        .navigationDestination(for: Order.self) { newValue in
            OrderEditView(order: newValue)
        }
        .onChange(of: orderFilter) { newValue in
            fetchedOrders.nsPredicate = searchPredicate(searchText.wrappedValue)
        }
    }
    
    @ViewBuilder
    var toolbarItems: some View {
        NavigationLink(value: OrdersView.newOrderLabel as String) {
            Label("Add Order", systemImage: "plus")
        }
        .id(UUID())
        
        Menu {
            Picker("Layout", selection: $layout) {
                ForEach(BrowserLayout.allCases) { option in
                    Label(option.title, systemImage: option.imageName)
                        .tag(option)
                }
            }
            .pickerStyle(.inline)
            
            Picker("Filter", selection: $orderFilter) {
                Label("All", systemImage: "tray.full")
                    .tag(OrderFilter.all)
                Label("Uncompleted", systemImage: "pencil.and.ellipsis.rectangle")
                    .tag(OrderFilter.uncompleted)
            }
            .pickerStyle(.inline)
            
        } label: {
            Label("Layout Options", systemImage: layout.imageName)
                .labelStyle(.iconOnly)
        }
    }
    
    @ViewBuilder
    var list: some View {
        OrdersListView(orders: Binding(get: {getOrderProperties(fetchedOrders)}, set: {_ in }))
    }
    
    @ViewBuilder
    var grid: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                OrdersGridView(orders: Binding(get: {getOrderProperties(fetchedOrders)}, set: {_ in }), width: geometryProxy.size.width)
            }
        }
    }
    
    // MARK: - Functions
    
    private func searchPredicate(_ searchText: String) -> NSPredicate? {
        let searchTextPredicate = NSPredicate(format: "isFinal == true")
        
        switch orderFilter {
        case .all:
            return searchTextPredicate
        case .uncompleted:
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                searchTextPredicate,
                NSPredicate(format: "statusCode != %@", Order.Status.completed.rawValue)
            ])
        }
    }
    
    private func getOrderProperties(_ fetchedOrders: FetchedResults<Order>) -> [Order] {
        let searchText = searchText.wrappedValue
        if !searchText.isEmpty {
            return Array(fetchedOrders)
                .filter({ $0.name.range(of: searchText, options: .caseInsensitive) != nil })
        }
        
        return Array(fetchedOrders)
    }
}

// MARK: - SortField

enum OrderFilter: Hashable {
    case all
    case uncompleted
}
