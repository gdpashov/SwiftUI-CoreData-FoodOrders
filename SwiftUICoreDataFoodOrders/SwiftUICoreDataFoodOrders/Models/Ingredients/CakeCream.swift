//
//  CakeCream.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 21.02.23.
//

import SwiftUI

struct CakeCream: Ingredient {
    var id: String
    var name: String
    var flavors: [Flavor]
    var foregroundColor: Color
    static var imageAssetName: String = "CakeCream"
    static var categoryName: String = "Cream"
}

extension CakeCream {
    static let saltyButter = CakeCream(
        id: "CC01",
        name: String(localized: "Salty Butter", bundle: .main, comment: "Salty Butter."),
        flavors: [.salty(3), .spicy(2)],
        foregroundColor: .yellow
    )
    
    static let sweetButter = CakeCream(
        id: "CC02",
        name: String(localized: "Sweet Butter", bundle: .main, comment: "Sweet Butter."),
        flavors: [.salty(1), .sweet(3)],
        foregroundColor: .yellow
    )
    
    static let chocolate = CakeCream(
        id: "CC03",
        name: String(localized: "Chocolate", bundle: .main, comment: "Chocolate."),
        flavors: [.salty(1), .sweet(2), .bitter(1)],
        foregroundColor: .brown
    )
    
    static let spicy = CakeCream(
        id: "CC04",
        name: String(localized: "Spicy", bundle: .main, comment: "Spicy."),
        flavors: [.salty(1), .sour(1), .spicy(3)],
        foregroundColor: .orange
    )
    
    static let strawberry = CakeCream(
        id: "CG05",
        name: String(localized: "Strawberry", bundle: .main, comment: "Strawberry."),
        flavors: [.sweet(3)],
        foregroundColor: .pink
    )
    
    static let lemon = CakeCream(
        id: "CG06",
        name: String(localized: "Lemon", bundle: .main, comment: "Lemon."),
        flavors: [.spicy(1), .sweet(1), .sour(3)],
        foregroundColor: .yellow
    )
    
    static let all = [saltyButter, sweetButter, chocolate, spicy, strawberry, lemon]
    
    static var allById = {
        return getAllById()
    }()
}
