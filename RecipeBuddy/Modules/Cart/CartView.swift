//
//  CartView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 14/08/25.
//

import SwiftUI

struct CartView: View {
    var ingredients: [IngredientModel] = []
    @StateObject private var viewModel = CartViewModel()
    @State private var showingShare = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack {
                    ForEach(ingredients, id: \.name) { ingredient in
                        ItemIngredientView(isChecked: true, title: ingredient.name, quantity: ingredient.quantity)
                            .allowsHitTesting(false)
                    }
                }
                .padding(16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clrPrimaryBackground)
        .navigationTitle("Ingredient Needs")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingShare) {
            ShareSheet(activityItems: [viewModel.makeShoppingList(for: ingredients)])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems,
                                 applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    CartView()
}
