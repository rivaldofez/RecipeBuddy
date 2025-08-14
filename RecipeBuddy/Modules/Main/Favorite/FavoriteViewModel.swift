//
//  FavoriteViewModel.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import Foundation
import Combine

@MainActor
final class FavoriteViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var searchQuery: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: RecipeRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var filteredRecipes: [RecipeModel] = []
    
    init(repository: RecipeRepositoryProtocol = RecipeRepository()) {
        self.repository = repository
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.applySearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func applySearch(query: String) {
        guard !query.isEmpty else {
            filteredRecipes = recipes
            return
        }
        filteredRecipes = recipes.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.ingredients.contains(where: { $0.name.lowercased().contains(query.lowercased()) })
        }
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        let data = await repository.getRecipes(sortByTimeAscending: false, filterTags: [], isFavorite: true)
        if data.isEmpty {
            errorMessage = "Oops, you don't have any favorite recipes yet!"
        }
        self.recipes = data
        self.filteredRecipes = data
        self.isLoading = false
    }
}
