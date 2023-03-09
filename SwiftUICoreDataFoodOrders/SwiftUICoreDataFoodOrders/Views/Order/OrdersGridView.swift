//
//  OrdersGridView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 1.03.23.
//

import SwiftUI

struct OrdersGridView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    @Binding
    var orders: [Order]
    var width: Double
    
    var useReducedImageSize: Bool {
        #if os(iOS)
        if sizeClass == .compact {
            return true
        }
        #endif
        if dynamicTypeSize >= .xxxLarge {
            return true
        }
        
        #if os(iOS)
        if width <= 390 {
            return true
        }
        #elseif os(macOS)
        if width <= 520 {
            return true
        }
        #endif
        
        return false
    }
    
    var imageWidth: Double {
        #if os(iOS)
        return useReducedImageSize ? 60 : 100
        #else
        return useReducedImageSize ? 40 : 80
        #endif
    }
    
    var cellWidth: Double {
        useReducedImageSize ? 100 : 150
    }
    
    var gridItems: [GridItem] {
        [GridItem(.adaptive(minimum: cellWidth), spacing: 20, alignment: .top)]
    }
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 20) {
            ForEach(orders, id: \.id) { order in
                NavigationLink(value: order) {
                    VStack {
                        let orderFoods = (order.orderFoods?.allObjects ?? []) as! [OrderFood]
                        
                        OrderImageView(orderFoods: orderFoods)
                            .frame(width: imageWidth, height: imageWidth)
                        
                        VStack {
                            Text(order.name)
                            
                            HStack(spacing: 4) {
                                order.status?.image
                                Text(order.status?.title ?? "")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                        .multilineTextAlignment(.center)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

