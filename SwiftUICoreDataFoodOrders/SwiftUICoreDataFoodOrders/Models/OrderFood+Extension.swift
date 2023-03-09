//
//  OrderFood+Extension.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 1.03.23.
//

import Foundation
import CoreData

extension OrderFood {
    // MARK: - Functions
    
    static func newOrderFood(viewContext: NSManagedObjectContext, food: Food?) -> OrderFood {
        let orderFood = OrderFood(context: viewContext)
        orderFood.food = food
        orderFood.count = 1
        orderFood.addedDate = Date()
        return orderFood
    }
}
