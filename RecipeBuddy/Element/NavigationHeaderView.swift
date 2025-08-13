//
//  NavigationHeaderView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct NavigationHeaderView: View {
    var title: String
    var didTapLeftButton: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                didTapLeftButton?()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .tint(.clrDarkest)
            }
            
            Spacer()
            
            Text(title)
                .font(.plusJakartaBold(size: 18))
                .foregroundStyle(Color.clrDarkest)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(24)
    }
}

#Preview {
    NavigationHeaderView(title: "Recipe Detail")
}
