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
	
	// Data Controller for review request notification
	@StateObject var dataController: ReviewManager
	
	init() {
		let dataController = ReviewManager()
		_dataController = StateObject(wrappedValue: dataController)
	}
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(dataController)
				.onAppear(perform: dataController.requestReview)
				.preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
