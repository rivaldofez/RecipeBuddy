//
//  RecipeModel.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

// MARK: - WelcomeElement
struct RecipeModel: Codable, Hashable {
    var id, title: String
    var tags: [String]
    var minutes: Int
    var image: String
    var ingredients: [IngredientModel]
    var steps: [String]
    var isFavorite: Bool? = false
}

// MARK: - Ingredient
struct IngredientModel: Codable, Hashable {
    var name, quantity: String
}
