//
//  HomeViewModel.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import SwiftUI

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var searchQuery: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: RecipeRepositoryProtocol
    
    init(repository: RecipeRepositoryProtocol = RecipeRepository()) {
        self.repository = repository
    }
    
    var filteredRecipes: [RecipeModel] {
        guard !searchQuery.isEmpty else { return recipes }
        return recipes.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.ingredients.contains(where: { $0.name.lowercased().contains(searchQuery.lowercased()) })
        }
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        let data = await repository.getRecipes(sortByTimeAscending: false, filterTags: [], isFavorite: nil)
        if data.isEmpty {
            errorMessage = "No data available"
        }
        self.recipes = data
        self.isLoading = false
    }
}
