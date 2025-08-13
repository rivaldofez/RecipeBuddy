//
//  MainView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI




struct MainView: View {
    @State var selectedTab: MenuTab = .home
    
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                TabBarView(menuTabs: MenuTab.allCases, selectedTab: selectedTab) { selectedTab in
                    self.selectedTab = selectedTab
                }
            }
        }
        .background(Color.clrPrimaryBackground)
    }
}

#Preview {
    MainView()
}
