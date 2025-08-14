//
//  HomeView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
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
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)

                    Text(error)
                        .font(.plusJakartaRegular(size: 14))
                        .foregroundStyle(.clrDarkest)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button(action: {
                        Task { await viewModel.load() }
                    }) {
                        Text("Retry")
                            .font(.plusJakartaMedium(size: 14))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.clrPrimaryAccent)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
                .padding()
            } else {
                // Success state
                ScrollView {
                    VStack(spacing: 16) {
                        SearchFieldView(searchText: $viewModel.searchQuery, placeholderText: "Search recipe")
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(viewModel.tags, id: \.self) { tag in
                                    let isSelected = viewModel.checkTagIsSelected(tag: tag)
                                    
                                    Button {
                                        viewModel.toggleSelectedTag(tag: tag)
                                        Task {
                                            await viewModel.load()
                                        }
                                    } label: {
                                        ChipView(
                                            title: tag.capitalized,
                                            backgroundColor: isSelected ? Color.clrPrimaryAccent :  Color.clrBlush,
                                            textColor: isSelected ? Color.white : Color.clrDarkest,
                                            textSize: 16
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }

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
        .navigationTitle("Explore Recipe")
        .navigationDestination(for: RecipeModel.self) { recipe in
            DetailRecipeView(recipeId: recipe.id)
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
