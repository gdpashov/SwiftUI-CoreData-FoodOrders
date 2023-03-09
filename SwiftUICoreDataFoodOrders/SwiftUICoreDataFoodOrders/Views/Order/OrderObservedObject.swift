//
//  OrderObservedObject.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 1.03.23.
//

import SwiftUI

class OrderObservedObject: ObservableObject {
    @Published var order: Order
    
    init(order: Order) {
        self.order = order
    }
}
