//
//  Ingredient.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 21.02.23.
//

import SwiftUI

protocol Ingredient: Identifiable, Hashable {
    var id: String { get }
    var name: String { get }
    var flavors: [Flavor] { get }
    var foregroundColor: Color { get }
    static var imageAssetName: String { get }
    static var categoryName: String { get }
    static var all: [Self] { get }
    static var allById: [String: Self] { get }
}

extension Ingredient {
    static func getAllById() -> [String: Self] {
        return Dictionary(uniqueKeysWithValues: all.map{ ($0.id, $0) })
    }
}
