//
//  ChipView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct ChipView: View {
    let title: String
    let backgroundColor: Color = .clrPrimaryAccent
    let textColor: Color = .white
    let textSize: CGFloat = 14
    
    var body: some View {
        Text(title)
            .font(.plusJakartaBold(size: textSize))
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(backgroundColor)
            .clipShape(Capsule())
            .foregroundStyle(textColor)
    }
}


#Preview {
    ChipView(title: "Protein")
}
