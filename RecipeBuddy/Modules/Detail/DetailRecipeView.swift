//
//  DetailRecipeView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI
import Kingfisher

struct DetailRecipeView: View {
    @StateObject private var viewModel = DetailRecipeViewModel()
    let recipeId: String
    
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
                        Task { await viewModel.load(id: recipeId) }
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
            } else if let recipe = viewModel.recipe {
                // Success state
                ScrollView {
                    VStack(spacing: 0) {
                        KFImage(URL(string: recipe.image))
                            .placeholder { ProgressView() }
                            .fade(duration: 0.25)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipped()
                        
                        Text(recipe.title)
                            .font(.plusJakartaBold(size: 22))
                            .foregroundStyle(Color.clrDarkest)
                            .padding(24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Text(recipe.tags.joined(separator: ", "))
                            .font(.plusJakartaRegular(size: 16))
                            .foregroundStyle(.clrPrimaryLabel)
                            .padding(.horizontal, 24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Ingredients")
                            .font(.plusJakartaBold(size: 22))
                            .foregroundStyle(Color.clrDarkest)
                            .padding(24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                ItemIngredientView(title: ingredient.name)
                                    .padding(.horizontal, 24)
                            }
                            
                        }
                        
                        Text("Instructions")
                            .font(.plusJakartaBold(size: 22))
                            .foregroundStyle(Color.clrDarkest)
                            .padding(24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        VStack(spacing: 24) {
                            ForEach(recipe.steps.indices, id: \.self) { index in
                                ItemInstructionView(stepTitle: "Step \(index + 1)", stepDescription: recipe.steps[index])
                                    .padding(.horizontal, 24)
                                
                            }
                            
                        }
                    }
                }
            }
        }
        .task { await viewModel.load(id: recipeId) }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clrPrimaryBackground)
        .navigationTitle("Detail Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.toggleFavorite(id: recipeId, isFavorite: !(viewModel.recipe?.isFavorite ?? false))
                    }
                } label: {
                    Image(systemName: viewModel.recipe?.isFavorite == true ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }
}
