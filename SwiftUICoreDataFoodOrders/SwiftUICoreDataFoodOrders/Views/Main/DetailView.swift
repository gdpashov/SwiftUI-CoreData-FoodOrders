//
//  DetailView.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 28.02.23.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    /// This value is a binding, and the superview must pass in its value.
    @Binding var selection: SidebarSelection?
    
    var body: some View {
        switch selection ?? .foods {
        case .orders:
            OrdersView()
        case .addOrder:
            let order = Order.newOrder(viewContext: viewContext, food: nil)
            OrderEditView(order: order)
        case .order(let order):
            OrderEditView(order: order)
        case .foods:
            CakesView()
        case .addFood:
            let food = Food.newFood(viewContext: viewContext)
            CakeEditView(food: food)
        case .food(let food):
            CakeEditView(food: food)
        }
    }
}
