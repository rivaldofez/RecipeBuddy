//
//  TabBarView.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import SwiftUI

enum MenuTab: Equatable, CaseIterable, Identifiable {
    case home
    case bookmark
    case setting
    
    var id: Int {
        switch self{
        case .home:
            return 0
        case .bookmark:
            return 1
        case .setting:
            return 2
        }
    }
    
    var activeIcon: String {
        switch self {
            
        case .home:
            return "ic_home_filled"
        case .bookmark:
            return "ic_bookmark_filled"
        case .setting:
            return "ic_setting_filled"
        }
    }
    
    var inactiveIcon: String {
        switch self {
            
        case .home:
            return "ic_home_unfilled"
        case .bookmark:
            return "ic_bookmark_unfilled"
        case .setting:
            return "ic_setting_unfilled"
        }
    }
    
    var title: String {
        switch self {
            
        case .home:
            return "Home"
        case .bookmark:
            return "Favorite"
        case .setting:
            return "Setting"
        }
    }
    
    var activeColor: Color {
        return .clrDarkest
    }
    
    var inactiveColor: Color {
        return .clrPrimaryAccent
    }
}

struct TabBarView: View {
    let menuTabs: [MenuTab]
    var selectedTab: MenuTab
    var didSelectTab: (MenuTab) -> Void
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.clrSeparator)
                .frame(maxWidth: .infinity)
                .frame(height: 2)
            
            Spacer()
            
            HStack {
                ForEach(menuTabs) { tabItem in
                    Spacer()
                    
                    Button {
                        didSelectTab(tabItem)
                    } label: {
                        VStack(spacing: 4) {
                            Image(selectedTab == tabItem ? tabItem.activeIcon : tabItem.inactiveIcon)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .scaledToFit()
                                .tint(selectedTab == tabItem ? tabItem.activeColor : tabItem.inactiveColor)
                            
                            Text(tabItem.title)
                                .font(selectedTab == tabItem ? .plusJakartaBold(size: 12) : .plusJakartaRegular(size: 12))
                                .foregroundStyle(selectedTab == tabItem ? tabItem.activeColor : tabItem.inactiveColor)
                        }
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(height: 80)
        .background(Color.clrPrimaryBackground)
    }
}

#Preview {
    TabBarView(menuTabs: MenuTab.allCases, selectedTab: .home, didSelectTab: { _ in })
}
