//
//  FavoriteView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
    @State private var isNavigationActive: Bool = false
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                // Loading state
                ProgressView("Loading recipes...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                // Error state
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.questionmark")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)

                    Text(error)
                        .font(.plusJakartaRegular(size: 14))
                        .foregroundStyle(.clrDarkest)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
            } else {
                // Success state
                ScrollView {
                    VStack(spacing: 16) {
                        SearchFieldView(searchText: $viewModel.searchQuery, placeholderText: "Search recipe")
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(16)

                        Text("Read Recipes")
                            .font(.plusJakartaBold(size: 16))
                            .foregroundStyle(Color.clrDarkest)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)

                        ForEach(viewModel.filteredRecipes, id: \.id) { item in
                            
                            NavigationLink(value: item) {
                                CardRecipeView(recipe: item)
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .task { await viewModel.load() }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clrPrimaryBackground)
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Favorites")
        .navigationDestination(for: RecipeModel.self) { recipe in
            DetailRecipeView(recipeId: recipe.id)
        }
    }
}

#Preview {
    NavigationView {
        FavoriteView()
    }
}
