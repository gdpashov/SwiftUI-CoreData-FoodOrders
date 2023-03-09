//
//  Order+Extension.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 1.03.23.
//

import SwiftUI
import CoreData

extension Order {
    // MARK: - Struct
    
    enum Status: String {
        case draft
        case ordered
        case preparing
        case delivering
        case completed
        
        public var title: String {
            switch self {
            case .draft:
                return String(localized: "Draft", bundle: .main, comment: "Order status.")
            case .ordered:
                return String(localized: "Ordered", bundle: .main, comment: "Order status.")
            case .preparing:
                return String(localized: "Preparing", bundle: .main, comment: "Order status.")
            case .delivering:
                return String(localized: "Delivering", bundle: .main, comment: "Order status.")
            case .completed:
                return String(localized: "Completed", bundle: .main, comment: "Order status.")
            }
        }
        
        var image: Image {
            switch self {
            case .completed:
                return Image(systemName: "checkmark.rectangle")
            default:
                return Image(systemName: "pencil.and.ellipsis.rectangle")
            }
        }
        
        var next: Status? {
            switch self {
            case .draft:
                return .ordered
            case .ordered:
                return .preparing
            case .preparing:
                return .delivering
            case .delivering:
                return .completed
            case .completed:
                return nil
            }
        }
    }
    
    // MARK: - Properties
    
    var status: Status? {
        get {
            statusCode != nil ? Status(rawValue: statusCode!) : nil
        }
        set {
            statusCode = newValue?.rawValue
        }
    }
    
    var name: String {
        String.localizedStringWithFormat(String(localized: "Order #%@", bundle: .main, comment: "Order."), (id ?? "").prefix(4) as CVarArg)
    }
    
    // MARK: - Functions
    
    static func newOrder(viewContext: NSManagedObjectContext, food: Food?) -> Order {
        let order = Order(context: viewContext)
        order.id = UUID().uuidString
        order.isFinal = false
        order.statusCode = Status.draft.rawValue
        order.statusDate = Date()
        order.orderFoods = NSSet(array: [OrderFood.newOrderFood(viewContext: viewContext, food: food)])
        return order
    }
    
    static func loadSampleOrders(viewContext: NSManagedObjectContext) {
        let addNewOrder = { (orderFoodRows: [(foodId: String, count: Int)]) in
            let order = Order(context: viewContext)
            order.id = UUID().uuidString
            order.isFinal = true
            order.statusCode = Status.ordered.rawValue
            order.statusDate = Date()
            
            var orderFoods: [OrderFood] = []
            for orderFoodRow in orderFoodRows {
                guard let food = viewContext.registeredObjects.first(where: { ($0 as? Food)?.id == orderFoodRow.foodId }) as? Food else {
                    continue
                }
                
                let orderFood = OrderFood(context: viewContext)
                orderFood.food = food
                orderFood.count = Int16(orderFoodRow.count)
                orderFood.addedDate = Date()
                orderFoods.append(orderFood)
            }
            
            order.orderFoods = NSSet(array: orderFoods)
        }
        
        addNewOrder([(foodId: "CD", count: 1), (foodId: "CL", count: 2)])
        addNewOrder([(foodId: "CD", count: 1), (foodId: "CC", count: 2)])
        addNewOrder([(foodId: "CS", count: 5)])
    }
}
