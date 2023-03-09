//
//  CakeImageView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 22.02.23.
//

import SwiftUI

struct CakeImageView: View {
    var ingredients: [any Ingredient]
    
    var body: some View {
        ZStack {
            ForEach(ingredients, id: \.id) { ingredient in
                Image(type(of: ingredient).imageAssetName)
                    .resizable()
                    .interpolation(.medium)
                    .scaledToFit()
                    .foregroundColor(ingredient.foregroundColor)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .compositingGroup()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
