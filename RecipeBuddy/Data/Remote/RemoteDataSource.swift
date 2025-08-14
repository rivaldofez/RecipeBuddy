//
//  RemoteDataSource.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import Foundation

protocol RemoteDataSourceProtocol {
    func fetchRecipes() async throws -> [RecipeModel]
}

struct RemoteDataSource: RemoteDataSourceProtocol {
    func fetchRecipes() async throws -> [RecipeModel] {
        guard let remoteURL = URL(string: "https://gist.githubusercontent.com/rivaldofez/088debabeb1178593960de7b748f7560/raw/e6a717b6542e3925378b0850cb125a61bd8daeba/recipebuddy.json") else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: remoteURL)
        return try JSONDecoder().decode([RecipeModel].self, from: data)
    }
}
