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
            VStack(spacing: 0) {
                switch selectedTab {
                case .home:
                    HomeView()
                case .favorite:
                    FavoriteView()
                case .setting:
                    SettingView()
                }
                
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
