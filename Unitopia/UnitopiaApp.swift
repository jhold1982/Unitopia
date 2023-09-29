//
//  UnitopiaApp.swift
//  Unitopia
//
//  Created by Justin Hold on 3/30/23.
//

import SwiftUI

@main
struct UnitopiaApp: App {
	@AppStorage("isDarkMode") private var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            ContentView()
				.preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
