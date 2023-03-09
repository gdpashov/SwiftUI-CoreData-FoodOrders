//
//  Sidebar.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 21.02.23.
//

import SwiftUI

enum SidebarSelection: Hashable {
    case orders
    case addOrder
    case order(Order)
    case foods
    case addFood
    case food(Food)
}

struct Sidebar: View {
    /// The person's selection in the sidebar.
    ///
    /// This value is a binding, and the superview must pass in its value.
    @Binding var selection: SidebarSelection?
    
    var body: some View {
        List(selection: $selection) {
            OrdersCard(selection: $selection)
            
            Section {
                FoodsCard(selection: $selection)
            }
            
            Section {
                TopFoodsCard()
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Ordering Cakes")
        #if os(macOS)
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        #endif
    }
}
