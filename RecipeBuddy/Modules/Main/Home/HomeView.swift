//
//  HomeView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct HomeView: View {
    @State var searchQuery: String = ""
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                ScrollView {
                    VStack(spacing: 16) {
                        SearchFieldView(searchText: $searchQuery, placeholderText: "Search recipe")
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(16)
                        
                        Text("My Recipes")
                            .font(.plusJakartaBold(size: 16))
                            .foregroundStyle(Color.clrDarkest)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        ForEach(0..<20) { item in
                            CardRecipeView()
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.bottom, 16)
                }
                
                Spacer()
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clrPrimaryBackground)
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Explore Recipe")
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
