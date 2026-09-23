//
//  MainTabView.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("Favorites", systemImage: "star") {
                FavoritesView()
            }
            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    MainTabView()
        .modelContainer(
            for: [ConversionRecord.self, FavoriteUnitPair.self],
            inMemory: true
        )
}
