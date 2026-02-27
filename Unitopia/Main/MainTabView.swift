//
//  MainTabView.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import SwiftUI

/// The root navigation container for the app after the welcome screen.
///
/// Hosts three tabs: Home (dashboard), Favorites, and Settings.
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "star") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(
            for: [ConversionRecord.self, FavoriteUnitPair.self],
            inMemory: true
        )
        .environmentObject(ReviewManager())
}
