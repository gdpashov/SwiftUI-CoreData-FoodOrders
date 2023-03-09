//
//  CakesListView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 27.02.23.
//

import SwiftUI

struct CakesListView: View {
    @Binding
    var foodProperties: [CakesView.FoodProperties]
    
    var imageWidth: Double {
        #if os(macOS)
        return 30
        #else
        return 60
        #endif
    }
    
    var body: some View {
        List(foodProperties, id: \.food.id) { foodProperties in
            let food = foodProperties.food
            
            NavigationLink(value: food) {
                HStack {
                    CakeImageView(ingredients: food.ingredients)
                        .frame(width: imageWidth, height: imageWidth)
                    
                    Text(food.name ?? "")
                    
                    Spacer()
                    
                    if let flavor = foodProperties.flavorMaxIntensity {
                        HStack(spacing: 4) {
                            flavor.image
                            Text(flavor.name)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
