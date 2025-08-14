//
//  ChipView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct ChipView: View {
    let title: String
    let backgroundColor: Color
    let textColor: Color
    let textSize: CGFloat
    
    init(title: String, backgroundColor: Color = .clrPrimaryAccent, textColor: Color = .white, textSize: CGFloat = 12) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.textSize = textSize
    }
    
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
