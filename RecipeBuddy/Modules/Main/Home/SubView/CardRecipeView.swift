//
//  CardRecipeView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI
import Kingfisher

struct CardRecipeView: View {
    let recipe: RecipeModel
    
    var body: some View {
        HStack(spacing: 16) {
            
            KFImage(URL(string: recipe.image))
                .placeholder { ProgressView() }
                .fade(duration: 0.25)
                .resizable()
                .frame(width: 100, height: 100)
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(spacing: 8) {
                Text(recipe.title)
                    .font(.plusJakartaMedium(size: 16))
                    .foregroundStyle(Color.clrDarkest)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(recipe.minutes) min")
                    .font(.plusJakartaRegular(size: 16))
                    .foregroundStyle(Color.clrPrimaryAccent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    ForEach(recipe.tags, id: \.self) { tag in
                        ChipView(title: tag.capitalized)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }
}



