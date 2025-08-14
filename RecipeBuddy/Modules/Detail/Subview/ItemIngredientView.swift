//
//  ItemIngredientView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct ItemIngredientView: View {
    @State var isChecked: Bool = false
    var title: String
    var quantity: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button {
                isChecked.toggle()
            } label: {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.clrPrimaryAccent)
            }
            
            (Text(title)
                .font(.plusJakartaRegular(size: 16))
                .foregroundStyle(.clrPrimaryLabel)
            +
            Text(" @\(quantity)")
                .font(.plusJakartaSemiBold(size: 14))
                .foregroundStyle(.clrPrimaryLabel))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ItemIngredientView(title: "1 lb pasta (fettuccine or spaghetti)", quantity: "10")
}
