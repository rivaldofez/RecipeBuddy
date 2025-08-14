//
//  MealPlanView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import SwiftUI

struct MealPlanView: View {
    @StateObject private var viewModel = MealPlanViewModel()
    @Namespace var animation
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10){
                        ForEach(viewModel.currentWeek, id: \.self) { day in
                            VStack(spacing: 10) {
                                Text(viewModel.extractDate(date: day, format: "dd"))
                                    .font(.plusJakartaSemiBold(size: 14))
                                
                                Text(viewModel.extractDate(date: day, format: "EEE"))
                                    .font(.plusJakartaSemiBold(size: 14))
                                
                                Circle()
                                    .fill(.white)
                                    .frame(width: 8, height: 8)
                                    .opacity(viewModel.isToday(date: day) ? 1 : 0 )
                            }
                            .foregroundStyle(viewModel.isToday(date: day) ? Color.clrBlush : Color.clrDarkest)
                            .frame(width: 45, height: 90)
                            .background(
                                ZStack {
                                    if viewModel.isToday(date: day) {
                                        Capsule()
                                            .fill(Color.clrPrimaryAccent)
                                            .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                    }
                                }
                            )
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation {
                                    viewModel.currentDay = day
                                }
                                Task {
                                    await viewModel.load(date: viewModel.currentDay.toString())
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView("Loading recipes...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .font(.plusJakartaRegular(size: 14))
                            .foregroundStyle(.clrDarkest)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.currentMealPlanRecipes, id: \.id) { item in
                                NavigationLink(value: item) {
                                    CardRecipeView(recipe: item)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
                Spacer()
            }
        }
        .task {
            await viewModel.load(date: viewModel.currentDay.toString())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clrPrimaryBackground)
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Meal Plan")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(value: viewModel.currentDay) {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationDestination(for: Date.self) { date in
            AddMealPlanView(currentDate: date.toString())
        }
        .navigationDestination(for: RecipeModel.self) { recipe in
            DetailRecipeView(recipeId: recipe.id)
        }
    }
}

#Preview {
    MealPlanView()
}

