//
//  PickerCakes.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 7.03.23.
//

import SwiftUI

struct PickerCakes: View {
    @Environment(\.dismiss) private var dismiss
    
    var foodProperties: [CakesView.FoodProperties]
    var imageWidth: Double
    
    @Binding
    var food: Food?
    
    @Binding
    var isShowing: Bool
    
    var body: some View {
        List(selection: $food) {
            HStack {
                Image(systemName: "shippingbox")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth, height: imageWidth)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading) {
                    Text("None")
                }
                
                Spacer()
                
                if self.food == nil {
                    Image(systemName: "checkmark")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.food = nil
                dismiss()
            }
            
            ForEach(foodProperties, id: \.food.id) { foodProperties in
                let food = foodProperties.food
                
                HStack {
                    CakeImageView(ingredients: food.ingredients)
                        .frame(width: imageWidth, height: imageWidth)
                    
                    VStack(alignment: .leading) {
                        Text(food.name ?? "")
                        
                        if let flavor = foodProperties.flavorMaxIntensity {
                            HStack(spacing: 4) {
                                flavor.image
                                Text(flavor.name)
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    if self.food == food {
                        Image(systemName: "checkmark")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.food = food
                    dismiss()
                }
                
            }
        }
        .onAppear{
            isShowing = true
        }
        .onDisappear{
            isShowing = false
        }
    }
}
