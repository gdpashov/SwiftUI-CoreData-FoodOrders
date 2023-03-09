//
//  CakeEditView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 22.02.23.
//

import SwiftUI
import CoreData

struct CakeEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
     
    @ObservedObject
    var foodObservedObject: FoodObservedObject
    
    init(food: Food) {
        foodObservedObject = FoodObservedObject(food: food)
    }
    
    var body: some View {
        ZStack {
            #if os(macOS)
            HSplitView {
                cakeImageView
                    .layoutPriority(1)

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
                        cakeImageView
                        contentView
                    }
                } else {
                    HStack(spacing: 0) {
                        cakeImageView
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
                    delete()
                    dismiss()
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle(foodObservedObject.food.name ?? "")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        #endif
        .onDisappear {
            save()
        }
    }
    
    @ViewBuilder
    var cakeImageView: some View {
        CakeImageView(ingredients: foodObservedObject.food.ingredients)
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
            .listRowInsets(.init())
            .padding(.horizontal, 40)
            .padding(.vertical)
            .background()
    }
    
    @ViewBuilder
    var contentView: some View {
        Section("Cake") {
            if foodObservedObject.food.name != nil {
                TextField("Name", text: Binding($foodObservedObject.food.name, ""), prompt: Text("Cake Name"))
                    .autocorrectionDisabled(true)
            }
        }
        
        Section("Flavor Profile") {
            Grid {
                let allFlavors = foodObservedObject.food.extendedToAllFlavors
                let flavorMaxIntensity = allFlavors.flavorMaxIntensity()
                let maxIntensity: Int = flavorMaxIntensity?.intensity ?? 0
                
                ForEach(allFlavors) { flavor in
                    let isMaxIntensity = flavor == flavorMaxIntensity
                    let intensity: Int = flavor.intensity
                    
                    GridRow {
                        flavor.image
                        
                        Text(flavor.name)
                            .gridCellAnchor(.leading)
                        
                        Gauge(value: Double(intensity), in: 0 ... Double(maxIntensity)) {
                            EmptyView()
                        }
                        .tint(isMaxIntensity ? Color.accentColor : Color.secondary)
                        .labelsHidden()
                         
                        Text(flavor.intensity.formatted())
                            .gridCellAnchor(.trailing)
                    }
                    .foregroundStyle(isMaxIntensity ? .primary : .secondary)
                }
            }
        }
        
        Section("Ingredients") {
            let allIngredientCategories: [(id: String, ingredientType: any Ingredient.Type, binding: Binding<String?>, isOptional: Bool)] = [
                (id: CakeBase.categoryName, ingredientType: CakeBase.self, binding: $foodObservedObject.food.baseId, isOptional: false),
                (id: CakeGlaze.categoryName, ingredientType: CakeGlaze.self, binding: $foodObservedObject.food.glazeId, isOptional: false),
                (id: CakeCream.categoryName, ingredientType: CakeCream.self, binding: $foodObservedObject.food.creamId, isOptional: true),
                (id: CakeTopping.categoryName, ingredientType: CakeTopping.self, binding: $foodObservedObject.food.toppingId, isOptional: true)
            ]
            
            ForEach(allIngredientCategories, id: \.id) { category in
                if foodObservedObject.food.name != nil {
                    Picker(category.id, selection: category.binding) {
                        if category.isOptional {
                            Section {
                                Text("None")
                                    .tag(nil as String?)
                            }
                        }
                        
                        ForEach(category.ingredientType.all, id: \.id) { ingredient in
                            Text(ingredient.name)
                                .tag(ingredient.id as String?)
                        }
                    }
                    .disabled(category.id == CakeTopping.categoryName && foodObservedObject.food.creamId == nil)
                }
            }
            .onChange(of: foodObservedObject.food.creamId) { newValue in
                if newValue == nil {
                    foodObservedObject.food.toppingId = nil
                }
            }
        }
    }
    
    // MARK: - Functions
    
    private func save() {
        if viewContext.hasChanges {
            foodObservedObject.food.isFinal = true
            
            // Remove order row drafts
            for insertedObject in viewContext.insertedObjects {
                if let food = insertedObject as? Food {
                    if !food.isFinal {
                        viewContext.delete(food)
                    }
                }
            }
            
            // FIXME: Catch the error and display it to the user
            try! viewContext.save()
        }
    }
    
    private func delete() {
        if foodObservedObject.food.isFinal {
            // Delete all related food rows
            let fetchRequest = NSFetchRequest<OrderFood>(entityName: "OrderFood")
            fetchRequest.predicate = NSPredicate(format: "food == %@", foodObservedObject.food)
            fetchRequest.sortDescriptors = []
            
            let orderFoods = try! viewContext.fetch(fetchRequest)
            for orderFood in orderFoods {
                viewContext.delete(orderFood)
            }
            
            viewContext.delete(foodObservedObject.food)
            // FIXME: Catch the error and display it to the user
            try! viewContext.save()
        } else {
            viewContext.rollback()
        }
    }
}
