//
//  FavoriteView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct FavoriteView: View {
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<20) { item in
                        CardRecipeView()
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clrPrimaryBackground)
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Favorites")
    }
}

#Preview {
    NavigationView {
        FavoriteView()
    }
}
