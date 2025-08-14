//
//  AddMealPlanView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import SwiftUI

struct AddMealPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddMealPlanViewModel()
    var currentDate: String
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
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
                        Task { await viewModel.load(date: currentDate) }
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
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.recipes, id: \.id) { item in
                            Button {
                                viewModel.toggleSelectedRecipe(id: item.id)
                            } label: {
                                CardRecipeView(recipe: item)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(viewModel.checkIsSelected(id: item.id) ? Color.clrBlush : Color.clear)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .task { await viewModel.load(date: currentDate) }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clrPrimaryBackground)
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Add Meal Plan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await viewModel.save(date: currentDate)
                        dismiss()
                    }
                } label: {
                    Image(systemName: "checkmark")
                }
                .accessibilityLabel("Save and update current data")
            }
        }
    }
}

#Preview {
    AddMealPlanView(currentDate: "")
}
