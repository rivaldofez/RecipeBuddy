//
//  AddMealPlanViewModel.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import Foundation

@MainActor
final class AddMealPlanViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var selectedRecipes: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: RecipeRepositoryProtocol
    
    init(repository: RecipeRepositoryProtocol = RecipeRepository()) {
        self.repository = repository
    }
    
    func load(date: String) async {
        isLoading = true
        errorMessage = nil
        
        let recipes = await repository.getRecipes(sortByTimeAscending: false, filterTags: [], isFavorite: nil)
        if recipes.isEmpty {
            errorMessage = "No data available"
        }
        
        let selectedRecipes = await repository.getMealPlan(date: date)

        
        self.recipes = recipes
        self.selectedRecipes = selectedRecipes?.idRecipes.components(separatedBy: ",") ?? []
        self.isLoading = false
    }
    
    func save(date: String) async {
        await self.repository.insertMealPlan(mealPlan: .init(date: date, idRecipes: selectedRecipes.joined(separator: ",")))
    }
    
    func toggleSelectedRecipe(id: String) {
        if checkIsSelected(id: id) {
            selectedRecipes.removeAll(where: { $0 == id })
        } else {
            if let item = recipes.first(where: { $0.id == id }) {
                selectedRecipes.append(item.id)
            }
        }
    }
    
    func checkIsSelected(id: String) -> Bool {
        return selectedRecipes.contains(where: { $0 == id })
    }
    
}
