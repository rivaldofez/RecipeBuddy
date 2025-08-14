//
//  RecipeRepository.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import Foundation

protocol RecipeRepositoryProtocol {
    func getRecipes(sortByTimeAscending: Bool, filterTags: [String], isFavorite: Bool?) async -> [RecipeModel]
    func getRecipe(id: String) async -> RecipeModel?
    func updateFavoriteRecipe(for id: String, isFavorite: Bool) async -> Bool
}

struct RecipeRepository: RecipeRepositoryProtocol {
    private let remote: RemoteDataSourceProtocol
    private let local: LocalDataSourceProtocol

    init(remote: RemoteDataSourceProtocol = RemoteDataSource(),
         local: LocalDataSourceProtocol = LocalDataSource.shared) {
        self.remote = remote
        self.local = local
    }
    
    func getRecipes(sortByTimeAscending: Bool, filterTags: [String], isFavorite: Bool?) async -> [RecipeModel] {
        do {
            let remoteData = try await remote.fetchRecipes()
            try? local.insertIfNotExists(remoteData)
            return await (try? local.fetchRecipes(sortByTimeAscending: sortByTimeAscending, filterTags: filterTags, isFavorite: isFavorite)) ?? []
        } catch {
            let localData: [RecipeModel] = loadJSON(filename: "recipes")
            try? local.insertIfNotExists(localData)
            return await (try? local.fetchRecipes(sortByTimeAscending: sortByTimeAscending, filterTags: filterTags, isFavorite: isFavorite)) ?? []
        }
    }
    
    private func loadJSON<T: Decodable>(filename: String) -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("Couldn't find \(filename).json in main bundle.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename).json: \(error)")
        }
    }
    
    func updateFavoriteRecipe(for id: String, isFavorite: Bool) async -> Bool {
        return await (try? local.updateFavoriteRecipe(for: id, isFavorite: isFavorite)) ?? false
    }
    
    func getRecipe(id: String) async -> RecipeModel? {
        return try? await local.fetchRecipe(for: id)
    }
    
}
