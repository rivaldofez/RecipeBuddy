//
//  DetailRecipeViewModel.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import Foundation

@MainActor
final class DetailRecipeViewModel: ObservableObject {
    @Published var recipe: RecipeModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: RecipeRepositoryProtocol
    
    init(repository: RecipeRepositoryProtocol = RecipeRepository()) {
        self.repository = repository
    }
    
    func load(id: String) async {
        isLoading = true
        errorMessage = nil
        
        
        let data = await repository.getRecipe(id: id)
        if data == nil {
            errorMessage = "No data available"
        }
        self.recipe = data
        self.isLoading = false
    }
    
    func toggleFavorite(id: String, isFavorite: Bool) async {
        _ = await repository.updateFavoriteRecipe(for: id, isFavorite: isFavorite)
        self.recipe = await repository.getRecipe(id: id)
    }
}
