//
//  DetailRecipeView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct DetailRecipeView: View {
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    Image("sample")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()
                    
                    Text("Creamy Potato Pasta")
                        .font(.plusJakartaBold(size: 22))
                        .foregroundStyle(Color.clrDarkest)
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Text("A simple yet flavorful pasta recipe with a creamy tomato sauce, perfect for a quick weeknight dinner.")
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
                        ForEach(0..<10) { item in
                            ItemIngredientView(title: "1 lb pasta (fettuccine or spaghetti)")
                                .padding(.horizontal, 24)
                        }
                        
                    }
                    
                    Text("Instructions")
                        .font(.plusJakartaBold(size: 22))
                        .foregroundStyle(Color.clrDarkest)
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    VStack(spacing: 24) {
                        ForEach(0..<10) { item in
                            ItemInstructionView(stepTitle: "Step 1", stepDescription: "Heat olive oil in a large pan over medium heat. Add garlic and cook for 1 minute until fragrant.")
                                .padding(.horizontal, 24)
                            
                        }
                        
                    }
                    
                }
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clrPrimaryBackground)
        .navigationTitle("Detail Recipe")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    
    NavigationView {
        DetailRecipeView()
    }
    
}
