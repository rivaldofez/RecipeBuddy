//
//  RecipeRepository+Test.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import XCTest
@testable import RecipeBuddy

final class MockRemoteDataSource: RemoteDataSourceProtocol {
    var shouldThrowError = false
    var recipes: [RecipeModel] = []
    
    func fetchRecipes() async throws -> [RecipeModel] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return recipes
    }
}

final class MockLocalDataSource: LocalDataSourceProtocol {
    var insertedRecipes: [RecipeModel] = []
    var fetchedRecipes: [RecipeModel] = []
    var updatedFavoriteResult = false
    var fetchedRecipe: RecipeModel?
    var fetchedMealPlan: MealPlanModel?
    
    func insertIfNotExists(_ recipes: [RecipeModel]) throws {
        insertedRecipes.append(contentsOf: recipes)
    }
    
    func fetchRecipes(sortByTimeAscending: Bool, filterTags: [String], isFavorite: Bool?) async throws -> [RecipeModel] {
        return fetchedRecipes
    }
    
    func updateFavoriteRecipe(for id: String, isFavorite: Bool) throws -> Bool {
        return updatedFavoriteResult
    }
    
    func fetchRecipe(for id: String) async throws -> RecipeModel? {
        return fetchedRecipe
    }
    
    func fetchMealPlan(for date: String) async throws -> MealPlanModel? {
        return fetchedMealPlan
    }
    
    func inserMealPlan(_ mealPlan: MealPlanModel) throws {
        fetchedMealPlan = mealPlan
    }
}

final class RecipeRepositoryTests: XCTestCase {
    var mockRemote: MockRemoteDataSource!
    var mockLocal: MockLocalDataSource!
    var repository: RecipeRepository!
    
    override func setUp() {
        super.setUp()
        mockRemote = MockRemoteDataSource()
        mockLocal = MockLocalDataSource()
        repository = RecipeRepository(remote: mockRemote, local: mockLocal)
    }
    
    override func tearDown() {
        mockRemote = nil
        mockLocal = nil
        repository = nil
        super.tearDown()
    }
    
    func testGetRecipes_successFromRemote() async {
        // Arrange
        let expectedRecipes = [ RecipeModel(id: "1", title: "Pizza", tags: ["italian", "carbs"], minutes: 10, image: "image", ingredients: [.init(name: "Beef", quantity: "10 pcs")], steps: ["step 1", "step 2"])]
        mockRemote.recipes = expectedRecipes
        mockLocal.fetchedRecipes = expectedRecipes
        
        // Act
        let result = await repository.getRecipes(sortByTimeAscending: true, filterTags: [], isFavorite: nil)
        
        // Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, expectedRecipes.first?.title)
        XCTAssertEqual(mockLocal.insertedRecipes.count, 1)
    }
    
    func testGetRecipes_fallbackToLocalOnRemoteError() async {
        // Arrange
        mockRemote.shouldThrowError = true
        mockLocal.fetchedRecipes = [
            RecipeModel(id: "1", title: "Pizza", tags: ["italian", "carbs"], minutes: 10, image: "image", ingredients: [.init(name: "Beef", quantity: "10 pcs")], steps: ["step 1", "step 2"])
        ]
        
        // Act
        let result = await repository.getRecipes(sortByTimeAscending: false, filterTags: [], isFavorite: nil)
        
        // Assert
        XCTAssertEqual(result.first?.title, "Pizza")
    }
    
    func testUpdateFavoriteRecipe() async {
        // Arrange
        mockLocal.updatedFavoriteResult = true
        
        // Act
        let success = await repository.updateFavoriteRecipe(for: "1", isFavorite: true)
        
        // Assert
        XCTAssertTrue(success)
    }
    
    func testGetRecipe() async {
        // Arrange
        let recipe = RecipeModel(id: "1", title: "Pizza", tags: ["italian", "carbs"], minutes: 10, image: "image", ingredients: [.init(name: "Beef", quantity: "10 pcs")], steps: ["step 1", "step 2"])
        mockLocal.fetchedRecipe = recipe
        
        // Act
        let result = await repository.getRecipe(id: "1")
        
        // Assert
        XCTAssertEqual(result?.title, "Pizza")
    }
    
    func testGetMealPlan() async {
        // Arrange
        let mealPlan = MealPlanModel(date: "2025-08-14", idRecipes: "1")
        mockLocal.fetchedMealPlan = mealPlan
        
        // Act
        let result = await repository.getMealPlan(date: "2025-08-14")
        
        // Assert
        XCTAssertEqual(result?.date, "2025-08-14")
    }
    
    func testInsertMealPlan() async {
        // Arrange
        let mealPlan = MealPlanModel(date: "2025-08-14", idRecipes: "1")
        
        // Act
        await repository.insertMealPlan(mealPlan: mealPlan)
        
        // Assert
        XCTAssertEqual(mockLocal.fetchedMealPlan?.date, "2025-08-14")
    }
}
