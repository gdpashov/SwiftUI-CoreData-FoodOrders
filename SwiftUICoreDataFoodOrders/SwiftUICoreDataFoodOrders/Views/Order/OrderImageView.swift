//
//  OrderImageView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 1.03.23.
//

import SwiftUI

struct OrderImageView: View {
    var itemsCount = 3
    var orderFoods: [OrderFood]
    
    var body: some View {
        DiagonalStackView {
            ForEach(orderFoods.prefix(itemsCount)) { orderFood in
                CakeImageView(ingredients: orderFood.food?.ingredients ?? [])
            }
        }
    }
}
