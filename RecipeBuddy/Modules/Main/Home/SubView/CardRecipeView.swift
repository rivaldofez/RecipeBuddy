//
//  CardRecipeView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct CardRecipeView: View {
    var body: some View {
        HStack(spacing: 16) {
            Image("sample")
                .resizable()
                .frame(width: 100, height: 100)
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(spacing: 8) {
                Text("Avocado Toast with Egg")
                    .font(.plusJakartaMedium(size: 16))
                    .foregroundStyle(Color.clrDarkest)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("30 min")
                    .font(.plusJakartaRegular(size: 16))
                    .foregroundStyle(Color.clrPrimaryAccent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    ForEach(0..<2) { item in
                        ChipView(title: "Protein")
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CardRecipeView()
}


