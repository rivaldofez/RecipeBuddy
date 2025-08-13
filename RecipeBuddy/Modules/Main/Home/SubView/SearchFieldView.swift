//
//  SearchFieldView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var searchText: String
    var placeholderText: String

    var body: some View {
        HStack {
            Image("ic_search_unfilled")
                .tint(.clrPrimaryAccent)
            
            ZStack {
                TextField("", text: $searchText)
                    .font(.plusJakartaRegular(size: 16))
                    .foregroundStyle(Color.clrDarkest)
                
                if searchText.isEmpty {
                    Text(placeholderText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.plusJakartaRegular(size: 16))
                        .foregroundStyle(Color.clrDarkest.opacity(0.4))
                }
            }
        }
        .padding(16)
        .background(Color.clrBlush)
    }
}

#Preview {
    SearchFieldView(searchText: .constant(""), placeholderText: "Search recipes")
}
