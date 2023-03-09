//
//  CakeTopping.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 21.02.23.
//

import SwiftUI

struct CakeTopping: Ingredient {
    var id: String
    var name: String
    var flavors: [Flavor]
    var foregroundColor: Color
    static var imageAssetName: String = "CakeTopping"
    static var categoryName: String = "Topping"
}

extension CakeTopping {
    static let cherry = CakeTopping(
        id: "CT01",
        name: String(localized: "Cherry", bundle: .main, comment: "Cherry."),
        flavors: [.sweet(3)],
        foregroundColor: .red
    )
    
    static let chocolate = CakeTopping(
        id: "CT02",
        name: String(localized: "Chocolate", bundle: .main, comment: "Chocolate."),
        flavors: [.sweet(3), .bitter(1)],
        foregroundColor: .brown
    )
    
    static let strawberry = CakeTopping(
        id: "CT03",
        name: String(localized: "Strawberry", bundle: .main, comment: "Strawberry."),
        flavors: [.sweet(3)],
        foregroundColor: .pink
    )
    
    static let lemon = CakeTopping(
        id: "CT04",
        name: String(localized: "Lemon", bundle: .main, comment: "Lemon."),
        flavors: [.spicy(1), .sweet(1), .sour(3)],
        foregroundColor: .yellow
    )
    
    static let cheese = CakeTopping(
        id: "CT05",
        name: String(localized: "Cheese", bundle: .main, comment: "Cheese."),
        flavors: [.spicy(3), .salty(2)],
        foregroundColor: .yellow
    )
    
    static let all = [cherry, chocolate, strawberry, lemon, cheese]
    
    static var allById = {
        return getAllById()
    }()
}
