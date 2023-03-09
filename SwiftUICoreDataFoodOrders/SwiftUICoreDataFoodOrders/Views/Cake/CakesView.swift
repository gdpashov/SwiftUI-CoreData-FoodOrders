//
//  CakesView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 23.02.23.
//

import SwiftUI

struct CakesView: View {
    private static let newCakeLabel: String = "New"
    
    @State private var food: Food?
    
    @State private var _searchText: String = ""
    @State private var layout = BrowserLayout.grid
    @State private var sortField = FoodSortField.name
    
    typealias FoodProperties = (food: FetchedResults<Food>.Element, flavorMaxIntensity: Flavor?)
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Food.name, ascending: true)],
        predicate: NSPredicate(format: "isFinal == true"),
        animation: .default)
    var fetchedFoods: FetchedResults<Food>
    
    var searchText: Binding<String> {
        Binding {
            _searchText
        } set: { newValue in
            _searchText = newValue
            
            fetchedFoods.nsPredicate = searchPredicate(newValue)
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
        .navigationTitle("Cakes")
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
            case CakesView.newCakeLabel:
                let food = Food.newFood(viewContext: viewContext)
                CakeEditView(food: food)
            default:
                EmptyView()
            }
        }
        .navigationDestination(for: Food.self) { newValue in
            CakeEditView(food: newValue)
        }
    }
    
    @ViewBuilder
    var toolbarItems: some View {
        NavigationLink(value: CakesView.newCakeLabel) {
            Label("Add Cake", systemImage: "plus")
        }
        
        Menu {
            Picker("Layout", selection: $layout) {
                ForEach(BrowserLayout.allCases) { option in
                    Label(option.title, systemImage: option.imageName)
                        .tag(option)
                }
            }
            .pickerStyle(.inline)
            
            Picker("Sort", selection: $sortField) {
                Label("Name", systemImage: "textformat")
                    .tag(FoodSortField.name)
                Label("Flavor", systemImage: "fork.knife")
                    .tag(FoodSortField.flavor(.sweet(0)))
            }
            .pickerStyle(.inline)
            
            if case .flavor = sortField {
                Picker("Flavor", selection: $sortField) {
                    ForEach(Flavor.allCases) { flavor in
                        Text(flavor.name)
                            .tag(FoodSortField.flavor(flavor))
                    }
                }
                .pickerStyle(.inline)
            }
            
        } label: {
            Label("Layout Options", systemImage: layout.imageName)
                .labelStyle(.iconOnly)
        }
    }
    
    @ViewBuilder
    var list: some View {
        CakesListView(foodProperties: Binding(get: {getFoodProperties(fetchedFoods)}, set: {_ in }))
    }
    
    @ViewBuilder
    var grid: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                CakesGridView(foodProperties: Binding(get: {getFoodProperties(fetchedFoods)}, set: {_ in }), width: geometryProxy.size.width)
            }
        }
    }
    
    // MARK: - Functions
    
    private func searchPredicate(_ searchText: String) -> NSPredicate? {
        if !searchText.isEmpty {
            return NSPredicate(format: "isFinal == true AND name CONTAINS[cd] %@", searchText)
        } else {
            return NSPredicate(format: "isFinal == true")
        }
    }
    
    private func getFoodProperties(_ fetchedFoods: FetchedResults<Food>) -> [FoodProperties] {
        let foods = fetchedFoods
            .map { food in
                (food: food, flavorMaxIntensity: food.flavorMaxIntensity)
            }
        
        if case .flavor(let flavor) = sortField {
            var orderByLabel: [String: Int] = Dictionary(uniqueKeysWithValues: Flavor.allCases.map({ ($0.label, $0.order + 1) }) )
            orderByLabel[flavor.label] = 0
            
            return foods
                .sorted(by: {
                    if let firstLabel = $0.flavorMaxIntensity?.label, let secondLabel = $1.flavorMaxIntensity?.label, let firstOrder = orderByLabel[firstLabel], let secondOrder = orderByLabel[secondLabel] {
                        return firstOrder < secondOrder
                    }
                    return true
                })
        }
        
        return foods
    }
}

// MARK: - FoodSortField

enum FoodSortField: Hashable {
    case name
    case flavor(Flavor)
}
