//
//  Flavor.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 21.02.23.
//

import SwiftUI

enum Flavor: Hashable, CaseIterable, Identifiable {
    var id: String {
        label
    }
    
    static var allCases: [Flavor] = [.salty(0), .sweet(0), .bitter(0), .sour(0), .spicy(0)]
    
    case salty(Int), sweet(Int), bitter(Int), sour(Int), spicy(Int)
    
    init(label: String, intensity: Int) {
        switch label {
        case "salty":
            self = .salty(intensity)
        case "sweet":
            self = .sweet(intensity)
        case "bitter":
            self = .bitter(intensity)
        case "sour":
            self = .sour(intensity)
        case "spicy":
            self = .spicy(intensity)
        default:
            fatalError("Unknown label \(label)")
        }
    }
    
    var intensity: Int {
        switch self {
        case .salty(let intensity), .sweet(let intensity), .bitter(let intensity), .sour(let intensity), .spicy(let intensity):
            return intensity
        }
    }
    
    var label: String {
        switch self {
        case .salty:
            return "salty"
        case .sweet:
            return "sweet"
        case .bitter:
            return "bitter"
        case .sour:
            return "sour"
        case .spicy:
            return "spicy"
        }
    }
    
    var order: Int {
        switch self {
        case .salty:
            return 0
        case .sweet:
            return 1
        case .bitter:
            return 2
        case .sour:
            return 3
        case .spicy:
            return 4
        }
    }
    
    var name: String {
        switch self {
        case .salty:
            return String(localized: "Salty", bundle: .main, comment: "Salty flavor.")
        case .sweet:
            return String(localized: "Sweet", bundle: .main, comment: "Sweet flavor.")
        case .bitter:
            return String(localized: "Bitter", bundle: .main, comment: "Bitter flavor.")
        case .sour:
            return String(localized: "Sour", bundle: .main, comment: "Sour flavor.")
        case .spicy:
            return String(localized: "Spicy", bundle: .main, comment: "Spicy flavor.")
        }
    }
    
    var image: Image {
        switch self {
        case .salty:
            return Image("Salty", bundle: .main)
        case .sweet:
            return Image("Sweet", bundle: .main)
        case .bitter:
            return Image("Bitter", bundle: .main)
        case .sour:
            return Image("Sour", bundle: .main)
        case .spicy:
            return Image("Spicy", bundle: .main)
        }
    }
}

// MARK: - Array

extension Array where Element == Flavor {
    func extendToAllCasses() -> Self {
        let elements = Element.allCases + self
        
        return elements.reduce([String: Int](), {
            var result = $0
            result[$1.label] = (result[$1.label] ?? 0) + $1.intensity
            return result
        })
            .map({ Element(label: $0, intensity: $1) })
            .sorted(by: { $0.order < $1.order })
    }
    
    func flavorMaxIntensity() -> Element? {
        self.max(by: { $0.intensity < $1.intensity || $0.intensity == $1.intensity && $0.order > $1.order })
    }
}
