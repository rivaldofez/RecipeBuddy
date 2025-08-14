//
//  MealPlanViewModel.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import Foundation

@MainActor
final class MealPlanViewModel: ObservableObject {
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    @Published var currentSelectedRecipes: [String] = []
    @Published var currentMealPlanRecipes: [RecipeModel] = []
    @Published var recipes: [RecipeModel] = []
    
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: RecipeRepositoryProtocol

    init(repository: RecipeRepositoryProtocol = RecipeRepository()) {
        self.repository = repository
        fetchCurrentWeek()
    }
    
    func load(date: String) async {
        isLoading = true
        errorMessage = nil
        
        if self.recipes.isEmpty {
            let recipes = await repository.getRecipes(sortByTimeAscending: false, filterTags: [], isFavorite: nil)
            self.recipes = recipes
        }
        
        let selectedRecipes = await repository.getMealPlan(date: date)
        self.currentSelectedRecipes = selectedRecipes?.idRecipes.components(separatedBy: ",") ?? []
        self.currentMealPlanRecipes = recipes.filter({ currentSelectedRecipes.contains($0.id) })
        
        if currentMealPlanRecipes.isEmpty {
            errorMessage = "You don't have meal plan here, sure you can add it by yourself"
        } else {
            errorMessage = nil
        }
        
        self.isLoading = false
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else { return }
        
        (1...7).forEach { day in
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekDay)
            }
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
}
