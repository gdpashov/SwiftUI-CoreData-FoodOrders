//
//  OrderEditView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 1.03.23.
//

import SwiftUI

struct OrderEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Food.name, ascending: true)],
        predicate: NSPredicate(format: "isFinal == true"),
        animation: .default)
    private var fetchedFoods: FetchedResults<Food>
    
    @State
    private var isChildShowing: Bool = false
    
    @State
    private var _orderFoods: [OrderFood] = []
    
    private var orderFoods: Binding<[OrderFood]> {
        Binding {
            return _orderFoods
        } set: { newValue in
            _orderFoods = newValue.dropLast().filter({ $0.food != nil })
            if let lastElement = newValue.last {
                _orderFoods.append(lastElement)
            }
            // Append draft for new order row
            if !(_orderFoods.last?.food == nil) {
                _orderFoods.append(OrderFood.newOrderFood(viewContext: viewContext, food: nil))
            }
        }
    }
    
    @ObservedObject
    var orderObservedObject: OrderObservedObject
    
    init(order: Order) {
        orderObservedObject = OrderObservedObject(order: order)
    }
    
    var body: some View {
        ZStack {
            #if os(macOS)
            HSplitView {
                Form {
                    contentView
                }
                .formStyle(.grouped)
                .padding()
                .frame(minWidth: 300, idealWidth: 350, maxHeight: .infinity, alignment: .top)
            }
            #else
            WidthThresholdReader { widthThresholdProxy in
                if widthThresholdProxy.isCompact {
                    Form {
                        contentView
                    }
                } else {
                    HStack(spacing: 0) {
                        Divider().ignoresSafeArea()
                        Form {
                            contentView
                        }
                        .formStyle(.grouped)
                        .frame(width: 350)
                    }
                }
            }
            #endif
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    autoProcess()
                } label: {
                    Label("Process", systemImage: "play.fill")
                }
                .disabled(orderObservedObject.order.status == .draft || orderObservedObject.order.status == .completed)
                
                Button {
                    delete()
                    dismiss()
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle(orderObservedObject.order.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        #endif
        .onDisappear {
            if !isChildShowing && orderObservedObject.order.status == .draft {
                if orderFoods.wrappedValue.contains(where: { $0.food != nil }) {
                    save()
                } else {
                    delete()
                }
            }
        }
        .onAppear {
            if _orderFoods.isEmpty {
                // Init
                _orderFoods = ((orderObservedObject.order.orderFoods?.allObjects ?? []) as! [OrderFood])
                    .sorted(by: { ($0.addedDate ?? Date.distantPast) < ($1.addedDate ?? Date.distantPast) })
            }
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        Section("Status") {
            HStack {
                Text(orderObservedObject.order.status?.title ?? "")
                
                Spacer()
                
                orderObservedObject.order.status?.image
                    .foregroundColor(.secondary)
            }
            
            if let statusDate = orderObservedObject.order.statusDate {
                HStack {
                    Text("Modified")
                    
                    Spacer()
                    
                    Text(statusDate.formatted())
                        .foregroundColor(.secondary)
                }
            }
        }
        
        Section("Cakes") {
            let foodProperties = getFoodProperties(fetchedFoods)
            
            ForEach(orderFoods, id: \.self) { orderFood in
                HStack {
                    // Can not use Picker in navigationLink style as 1) it is not dismissed when it is tapped on nil; and 2) there is no way to detect when picker is shown to prevent from save changes on disappearance
                    NavigationLink {
                        PickerCakes(foodProperties: foodProperties, imageWidth: imageWidth, food: orderFood.food, isShowing: $isChildShowing)
                    } label: {
                        foodView(food: orderFood.food.wrappedValue)
                    }
                    .id(UUID())
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(String(orderFood.count.wrappedValue))
                        
                        Stepper("", value: orderFood.count, in: 1 ... 999)
                            .frame(maxWidth: 100)
                    }
                }
            }
            .disabled(orderObservedObject.order.status != .draft)
        }
        
        Section("Total") {
            let total = orderFoods.compactMap({ $0.food.wrappedValue != nil ? $0.count.wrappedValue : nil }).reduce(0, +)
            
            HStack {
                Text("Pieces")
                
                Spacer()
                
                Text(String(total))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var imageWidth: Double {
        #if os(macOS)
        return 30
        #else
        return 60
        #endif
    }
    
    @ViewBuilder
    func foodView(food: Food?) -> some View {
        if let food = food {
            HStack {
                CakeImageView(ingredients: food.ingredients)
                    .frame(width: imageWidth, height: imageWidth)
                
                VStack(alignment: .leading) {
                    Text(food.name ?? "")
                    
                    if let flavor = food.flavorMaxIntensity {
                        HStack(spacing: 4) {
                            flavor.image
                            Text(flavor.name)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
        } else {
            HStack {
                Image(systemName: "shippingbox")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth, height: imageWidth)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading) {
                    Text("Select Cake")
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Functions
    
    private func getFoodProperties(_ fetchedFoods: FetchedResults<Food>) -> [CakesView.FoodProperties] {
        return fetchedFoods
            .map { food in
                (food: food, flavorMaxIntensity: food.flavorMaxIntensity)
            }
    }
    
    private func save() {
        if viewContext.hasChanges {
            orderObservedObject.order.orderFoods = NSSet(array: orderFoods.wrappedValue.filter({ $0.food != nil }))
            orderObservedObject.order.status = .ordered
            orderObservedObject.order.isFinal = true
            
            // Remove order row drafts
            for insertedObject in viewContext.insertedObjects {
                if let order = insertedObject as? Order {
                    if !order.isFinal {
                        viewContext.delete(order)
                    }
                } else if let orderFood = insertedObject as? OrderFood {
                    if orderFood.food == nil {
                        viewContext.delete(orderFood)
                    }
                }
            }
            
            // FIXME: Catch the error and display it to the user
            try! viewContext.save()
        }
    }
    
    private func delete() {
        if orderObservedObject.order.isFinal {
            // Delete order rows
            if let anyOrderFoods = orderObservedObject.order.orderFoods {
                for anyOrderFood in anyOrderFoods {
                    if let orderFood = anyOrderFood as? OrderFood {
                        viewContext.delete(orderFood)
                    }
                }
            }
            
            viewContext.delete(orderObservedObject.order)
            try! viewContext.save()
        } else {
            viewContext.rollback()
        }
    }
    
    private func process() {
        guard let nextStatus = orderObservedObject.order.status?.next else {
            return
        }
        
        orderObservedObject.order.status = nextStatus
        try! viewContext.save()
    }
    
    private func autoProcess(_ seconds: any BinaryInteger = 20) {
        process()
        
        if orderObservedObject.order.status?.next != nil {
            // There is one more state at least
            Task {
                try await Task.sleep(
                    until: .now + .seconds(seconds),
                    tolerance: .seconds(2),
                    clock: .suspending
                )
                
                autoProcess()
            }
        }
    }
}
