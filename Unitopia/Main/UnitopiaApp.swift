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
   
   /// Tracks whether the user has seen the welcome screen.
   ///
   /// This value determines whether to show the welcome screen or the main app interface.
   /// It is set to `true` after the user dismisses the welcome screen.
   @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
   
   /// Stores the last app version the user has seen.
   ///
   /// This is used to determine if the welcome screen should be shown after an app update.
   /// It is updated to the current app version when the welcome screen is dismissed.
   @AppStorage("lastSeenVersion") private var lastSeenVersion: String = ""

   /// The review manager that handles requesting app store reviews.
   ///
   /// This object is created at app initialization and shared with child views
   /// as an environment object.
   @StateObject var reviewManager: ReviewManager

   /// The current app version obtained from the main bundle.
   ///
   /// This is used to compare against `lastSeenVersion` to determine if this is a new app version.
   private let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2.2"
   
   /// Initializes the app with required state objects.
   ///
   /// This initializer creates the review manager that will be used throughout the app.
   init() {
	   let reviewManager = ReviewManager()
	   _reviewManager = StateObject(wrappedValue: reviewManager)
   }

   /// The body of the application defining its scene structure.
   ///
   /// This sets up the main window group containing either the welcome screen or the main
   /// content view, based on whether the user needs to see the welcome screen.
   var body: some Scene {
	   WindowGroup {
		   if shouldShowWelcome() {
			   WelcomeScreenView(hasSeenWelcome: $hasSeenWelcome, lastSeenVersion: $lastSeenVersion)
				   .preferredColorScheme(.light)
		   } else {
			   ContentView()
				   .environmentObject(reviewManager)
				   .onAppear(perform: reviewManager.requestReview)
				   .preferredColorScheme(isDarkMode ? .dark : .light)
		   }
	   }
   }

   /// Determines if the welcome screen should be shown.
   ///
   /// This method returns `true` if either:
   /// - The user has never seen the welcome screen (`hasSeenWelcome` is `false`)
   /// - The app has been updated to a new version (`lastSeenVersion` doesn't match `currentVersion`)
   ///
   /// - Returns: A Boolean value indicating whether to show the welcome screen.
   private func shouldShowWelcome() -> Bool {
	   let isNewVersion = lastSeenVersion != currentVersion
	   return !hasSeenWelcome || isNewVersion
   }
}
