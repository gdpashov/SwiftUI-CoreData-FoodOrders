//
//  CakeBase.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 21.02.23.
//

import SwiftUI

struct CakeBase: Ingredient {
    var id: String
    var name: String
    var flavors: [Flavor]
    var foregroundColor: Color
    static var imageAssetName: String = "CakeBase"
    static var categoryName: String = "Base"
}

extension CakeBase {
    static let blueberry = CakeBase(
        id: "CB01",
        name: String(localized: "Blueberry", bundle: .main, comment: "Blueberry."),
        flavors: [.salty(1), .sweet(2)],
        foregroundColor: .blue
    )
    
    static let chocolate = CakeBase(
        id: "CB02",
        name: String(localized: "Chocolate", bundle: .main, comment: "Chocolate."),
        flavors: [.salty(1), .sweet(3), .bitter(1)],
        foregroundColor: .brown
    )
    
    static let sourCandy = CakeBase(
        id: "CB03",
        name: String(localized: "Sour Candy", bundle: .main, comment: "Sour Candy."),
        flavors: [.salty(1), .sweet(2), .sour(3)],
        foregroundColor: .yellow
    )
    
    static let strawberry = CakeBase(
        id: "CB04",
        name: String(localized: "Strawberry", bundle: .main, comment: "Strawberry."),
        flavors: [.sweet(3)],
        foregroundColor: .pink
    )
    
    static let plain = CakeBase(
        id: "CB05",
        name: String(localized: "Plain", bundle: .main, comment: "Plain."),
        flavors: [.salty(1), .sweet(1), .bitter(1)],
        foregroundColor: .orange
    )
    
    static let lemonade = CakeBase(
        id: "CB06",
        name: String(localized: "Lemonadey", bundle: .main, comment: "Lemonadey."),
        flavors: [.salty(1), .sweet(1), .sour(3)],
        foregroundColor: .yellow
    )
    
    static let all = [blueberry, chocolate, sourCandy, strawberry, plain, lemonade]
    
    static var allById = {
        return getAllById()
    }()
}
