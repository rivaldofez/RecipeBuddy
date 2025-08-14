//
//  HomeViewModel.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import SwiftUI

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var searchQuery: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedTags: [String] = []
    @Published var tags: [String] = []
    @Published var isAscending: Bool = false
    
    @Published private(set) var filteredRecipes: [RecipeModel] = []
    
    private let repository: RecipeRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: RecipeRepositoryProtocol = RecipeRepository()) {
        self.repository = repository
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        Publishers.CombineLatest3($searchQuery, $selectedTags, $isAscending)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates { lhs, rhs in
                lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2
            }
            .sink { [weak self] search, _, _ in
                self?.applySearch(query: search)
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
        
        let data = await repository.getRecipes(sortByTimeAscending: isAscending, filterTags: selectedTags, isFavorite: nil)
        if data.isEmpty {
            errorMessage = "No data available"
        } else {
            errorMessage = nil
        }
    
        self.recipes = data
        self.filteredRecipes = data
        
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
