//
//  Food+Extension.swift
//  SwiftUICoreDataFoodOrders
//
//  Created by Georgi Pashov on 22.02.23.
//

import Foundation
import CoreData

extension Food {
    var base: CakeBase? {
        getIngredient(ingredientId: baseId)
    }
    
    var glaze: CakeGlaze? {
        getIngredient(ingredientId: glazeId)
    }
    
    var cream: CakeCream? {
        getIngredient(ingredientId: creamId)
    }
    
    var topping: CakeTopping? {
        getIngredient(ingredientId: toppingId)
    }
    
    var ingredients: [any Ingredient] {
        let allIngredients: [(any Ingredient)?] = [base, glaze, cream, topping]
        return allIngredients.compactMap({ $0 })
    }
    
    var extendedToAllFlavors: [Flavor] {
        let allIngredients: [(any Ingredient)?] = [base, glaze, cream, topping]
        return allIngredients.compactMap({ $0?.flavors }).flatMap({ $0 }).extendToAllCasses()
    }
    
    var flavorMaxIntensity: Flavor? {
        let allIngredients: [(any Ingredient)?] = [base, glaze, cream, topping]
        return allIngredients.compactMap({ $0?.flavors }).flatMap({ $0 }).flavorMaxIntensity()
    }
    
    // MARK: - Functions
    
    func getIngredient<T: Ingredient>(ingredientId: String?) -> T? {
        return ingredientId != nil ? T.allById[ingredientId!] : nil
    }
    
    static func newFood(viewContext: NSManagedObjectContext) -> Food {
        let food = Food(context: viewContext)
        food.id = UUID().uuidString
        food.name = String(localized: "New", bundle: .main, comment: "New.")
        food.isFinal = false
        food.baseId = CakeBase.plain.id
        food.glazeId = CakeGlaze.chocolate.id
        return food
    }
    
    static func loadSampleFoods(viewContext: NSManagedObjectContext) {
        let addNewFood = { (id: String, name: String, base: CakeBase, glaze: CakeGlaze, cream: CakeCream?) in
            let food = Food(context: viewContext)
            food.id = id
            food.name = name
            food.isFinal = true
            food.baseId = base.id
            food.glazeId = glaze.id
            if cream != nil {
                food.creamId = cream!.id
            }
        }
        
        addNewFood("CC", "Choco", .plain, .chocolate, nil)
        addNewFood("CD", "Chocolate Dream", .chocolate, .chocolate, nil)
        addNewFood("CL", "Too Lemon", .lemonade, .lemon, .sweetButter)
        addNewFood("CS", "Spicy Girl", .plain, .spicy, .saltyButter)
    }
}
