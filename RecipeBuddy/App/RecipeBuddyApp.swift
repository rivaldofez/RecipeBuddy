//
//  RecipeBuddyApp.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 12/08/25.
//

import SwiftUI

@main
struct RecipeBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
            .tint(.clrPrimaryAccent)
            .preferredColorScheme(.light)
        }
    }
}
