//
//  FoodsCard.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 28.02.23.
//

import SwiftUI

struct FoodsCard: View {
    @Binding var selection: SidebarSelection?
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "isFinal == true"),
        animation: .default)
    var fetchedFoods: FetchedResults<Food>
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(value: SidebarSelection.foods) {
                Label("Cakes", systemImage: "shippingbox")
                
                Spacer()
            }
            .onTapGesture {
                selection = .foods
            }
            .buttonStyle(.borderless)
            .labelStyle(CardNavigationHeaderLabelStyle())
            
            SquareTilingView { itemsCount in
                ForEach(getFoodProperties(fetchedFoods, maxFoodsCount: itemsCount - 1), id: \.food.id) { foodProperties in
                    let food = foodProperties.food
                    
                    NavigationLink(value: SidebarSelection.food(food)) {
                        VStack(spacing: 0) {
                            CakeImageView(ingredients: food.ingredients)
                            
                            VStack(spacing: 0) {
                                Text(food.name ?? "")
                                    .font(.footnote)
                                
                                if let flavor = foodProperties.flavorMaxIntensity {
                                    HStack(spacing: 4) {
                                        flavor.image
                                        Text(flavor.name)
                                    }
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                }
                            }
                            .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .buttonStyle(.plain)
                    .padding(5)
                    // Patch to hide disclosure indicator
                    .padding(.trailing, -16)
                    .clipped()
                    .onTapGesture {
                        selection = .food(food)
                    }
                }
                
                // Add food
                NavigationLink(value: SidebarSelection.addFood) {
                    VStack(alignment: .center, spacing: 0) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .padding(10)
                        
                        Text("Add")
                            .font(.footnote)
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)
                .padding(5)
                // Patch to hide disclosure indicator
                .padding(.trailing, -16)
                .clipped()
                .onTapGesture {
                    selection = .addFood
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            
            Spacer()
        }
        .padding(5)
        .clipShape(ContainerRelativeShape())
        .background()
    }
    
    // MARK: - Functions
    
    private func getFoodProperties(_ fetchedFoods: FetchedResults<Food>, maxFoodsCount: Int) -> [CakesView.FoodProperties] {
        let foods = fetchedFoods
            .map { food in
                (food: food, flavorMaxIntensity: food.flavorMaxIntensity)
            }
        
        let foodsByLabel = Dictionary(grouping: foods, by: { $0.flavorMaxIntensity?.label ?? "" })
            .map({ $0.value })
            .sorted(by: { $0.count < $1.count })
        
        var randomFoods: [CakesView.FoodProperties] = []
        var remainFoodsCount = maxFoodsCount
        var remainFoodsByLabelCount = foodsByLabel.count
        for flavorFoods in foodsByLabel {
            let maxFlavorFoodsCount = (remainFoodsByLabelCount == 1) ? remainFoodsCount : remainFoodsCount / remainFoodsByLabelCount
            if maxFlavorFoodsCount < flavorFoods.count {
                randomFoods.append(contentsOf: flavorFoods.shuffled().prefix(maxFlavorFoodsCount))
                remainFoodsCount -= maxFlavorFoodsCount
            } else {
                randomFoods.append(contentsOf: flavorFoods)
                remainFoodsCount -= flavorFoods.count
            }
            
            remainFoodsByLabelCount -= 1
        }
        
        return randomFoods
    }
}
