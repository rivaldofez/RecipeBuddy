//
//  ItemInstructionView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

struct ItemInstructionView: View {
    var stepTitle: String
    var stepDescription: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(stepTitle)
                .font(.plusJakartaMedium(size: 16))
                .foregroundStyle(Color.clrPrimaryLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(stepDescription)
                .font(.plusJakartaRegular(size: 14))
                .foregroundStyle(Color.clrPrimaryAccent)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ItemInstructionView(stepTitle: "Step 1", stepDescription: "Heat olive oil in a large pan over medium heat")
}
