//
//  FoodObservedObject.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 23.02.23.
//

import SwiftUI

class FoodObservedObject: ObservableObject {
    @Published var food: Food
    
    init(food: Food) {
        self.food = food
    }
}
