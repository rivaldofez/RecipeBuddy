//
//  HomeViewModel.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var searchQuery: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedTags: [String] = []
    @Published var tags: [String] = []
    
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
        
        let data = await repository.getRecipes(sortByTimeAscending: false, filterTags: selectedTags, isFavorite: nil)
        if data.isEmpty {
            errorMessage = "No data available"
        } else {
            errorMessage = nil
        }
    
        self.recipes = data
        self.isLoading = false
        if tags.isEmpty {
            self.tags = Array(Set(recipes.flatMap { $0.tags }).prefix(5))
        }
    }
    
    func toggleSelectedTag(tag: String) {
        if checkTagIsSelected(tag: tag) {
            selectedTags.removeAll(where: { $0 == tag })
        } else {
            selectedTags.append(tag)
        }
    }
    
    func checkTagIsSelected(tag: String) -> Bool {
        return selectedTags.contains(where: { $0 == tag })
    }
}
