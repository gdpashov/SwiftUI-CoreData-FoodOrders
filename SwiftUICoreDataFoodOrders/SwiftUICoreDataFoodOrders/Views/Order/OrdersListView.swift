//
//  OrdersListView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 1.03.23.
//

import SwiftUI

struct OrdersListView: View {
    @Binding
    var orders: [Order]
    
    var imageWidth: Double {
        #if os(macOS)
        return 30
        #else
        return 60
        #endif
    }
    
    var body: some View {
        List(orders, id: \.id) { order in
            NavigationLink(value: order) {
                HStack {
                    let orderFoods = (order.orderFoods?.allObjects ?? []) as! [OrderFood]
                    
                    OrderImageView(orderFoods: orderFoods)
                        .frame(width: imageWidth, height: imageWidth)
                    
                    Text(order.name)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        order.status?.image
                        Text(order.status?.title ?? "")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
        }
    }
}
