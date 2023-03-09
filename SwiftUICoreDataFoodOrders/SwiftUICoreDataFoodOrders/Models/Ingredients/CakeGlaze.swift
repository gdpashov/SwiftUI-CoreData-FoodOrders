//
//  CakeGlaze.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 21.02.23.
//

import SwiftUI

struct CakeGlaze: Ingredient {
    var id: String
    var name: String
    var flavors: [Flavor]
    var foregroundColor: Color
    static var imageAssetName: String = "CakeGlaze"
    static var categoryName: String = "Glaze"
}

extension CakeGlaze {
    static let blueberry = CakeGlaze(
        id: "CG01",
        name: String(localized: "Blueberry", bundle: .main, comment: "Blueberry."),
        flavors: [.salty(1), .sweet(3)],
        foregroundColor: .blue
    )
    
    static let chocolate = CakeGlaze(
        id: "CG02",
        name: String(localized: "Chocolate", bundle: .main, comment: "Chocolate."),
        flavors: [.salty(1), .sweet(1), .bitter(1)],
        foregroundColor: .brown
    )
    
    static let sourCandy = CakeGlaze(
        id: "CG03",
        name: String(localized: "Sour Candy", bundle: .main, comment: "Sour Candy."),
        flavors: [.bitter(1), .sour(3), .spicy(2)],
        foregroundColor: .yellow
    )
    
    static let spicy = CakeGlaze(
        id: "CG04",
        name: String(localized: "Spicy", bundle: .main, comment: "Spicy."),
        flavors: [.salty(1), .sour(1), .spicy(3)],
        foregroundColor: .orange
    )
    
    static let strawberry = CakeGlaze(
        id: "CG05",
        name: String(localized: "Strawberry", bundle: .main, comment: "Strawberry."),
        flavors: [.sweet(3)],
        foregroundColor: .pink
    )
    
    static let lemon = CakeGlaze(
        id: "CG06",
        name: String(localized: "Lemon", bundle: .main, comment: "Lemon."),
        flavors: [.spicy(1), .sweet(1), .sour(3)],
        foregroundColor: .yellow
    )
    
    static let all = [blueberry, chocolate, sourCandy, spicy, strawberry, lemon]
    
    static var allById = {
        return getAllById()
    }()
}
