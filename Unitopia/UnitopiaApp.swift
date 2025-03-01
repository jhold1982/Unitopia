//
//  UnitopiaApp.swift
//  Unitopia
//
//  Created by Justin Hold on 3/30/23.
//

import SwiftUI

/// The main entry point for the Unitopia application.
///
/// This app struct serves as the root of the application, configuring global preferences
/// such as dark mode, initializing necessary managers, and setting up the initial view hierarchy.
@main
struct UnitopiaApp: App {
   /// Controls whether the app uses dark mode.
   ///
   /// This preference is persisted between app launches using AppStorage.
   @AppStorage("isDarkMode") private var isDarkMode = false
   
   /// The review manager that handles requesting app store reviews.
   ///
   /// This object is created at app initialization and shared with child views
   /// as an environment object.
   @StateObject var reviewManager: ReviewManager
   
   /// Initializes the app with required state objects.
   ///
   /// This initializer creates the review manager that will be used throughout the app.
   init() {
	   let reviewManager = ReviewManager()
	   _reviewManager = StateObject(wrappedValue: reviewManager)
   }
   
   /// The body of the application defining its scene structure.
   ///
   /// This sets up the main window group containing the ContentView, configures
   /// color scheme preferences, and initiates the review request flow when the app appears.
   var body: some Scene {
	   WindowGroup {
		   ContentView()
			   .environmentObject(reviewManager)
			   .onAppear(perform: reviewManager.requestReview)
			   .preferredColorScheme(isDarkMode ? .dark : .light)
	   }
   }
}
