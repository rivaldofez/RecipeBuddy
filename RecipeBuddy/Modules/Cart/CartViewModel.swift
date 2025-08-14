//
//  CartViewModel.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import Foundation

@MainActor
final class CartViewModel: ObservableObject {
    
    func makeShoppingList(for ingredients: [IngredientModel]) -> String {
        var result = "Ingredients you need to buy:\n\n"
        for ingredient in ingredients {
            result += "- \(ingredient.name) \(ingredient.quantity)\n"
        }
        return result
    }
    
}
