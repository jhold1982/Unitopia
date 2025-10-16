//
//  WelcomeScreenView.swift
//  Unitopia
//
//  Created by Justin Hold on 2/28/25.
//

import SwiftUI

/// A welcome screen view that presents app features to new users or after updates.
///
/// This view displays the app icon, a welcome message, and a list of key features
/// to introduce users to the application. It appears on first launch or after app updates
/// and can be dismissed using the "Get Started" button.
///
/// Example usage:
/// ```
/// WelcomeScreenView(
///     hasSeenWelcome: $hasSeenWelcome,
///     lastSeenVersion: $lastSeenVersion
/// )
/// ```
struct WelcomeScreenView: View {
	
	// MARK: - Properties
	
	/// A binding that tracks whether the user has seen the welcome screen.
	///
	/// This value is set to `true` when the user taps the "Get Started" button.
	@Binding var hasSeenWelcome: Bool
	
	/// A binding that stores the last app version the user has seen.
	///
	/// This is updated to the current version when the welcome screen is dismissed.
	@Binding var lastSeenVersion: String
	
	@State private var isAnimating: Bool = false
	
	/// The current app version obtained from the main bundle.
	///
	/// This value is used to update `lastSeenVersion` when the welcome screen is dismissed.
	private let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2.2"
	
	/// An array of features to display in the welcome screen.
	///
	/// Each feature includes a title, description, and a system image name to be used as an icon.
	let features = [
		Feature(
			title: "Comprehensive Unit Conversion",
			description: "Convert between hundreds of units across multiple categories, with precise results.",
			image: "pencil"
		),
		Feature(
			title: "User-Friendly Interface",
			description: "Enjoy a seamless experience with dark mode, haptic feedback, and a convenient reset button.",
			image: "sun.max"
		),
		Feature(
			title: "Offline Functionality",
			description: "Convert between units offline.",
			image: "keyboard"
		)
	]
	
	// MARK: - View Body
	
	/// The content and layout of the welcome screen view.
	var body: some View {
		VStack(spacing: 20) {
			ScrollView {
				VStack(spacing: 20) {
					
					Image("unitopiaIcon")
						.resizable()
						.scaledToFit()
						.frame(width: 144, height: 180)
						.clipShape(Circle())
						.shadow(color: .gray, radius: 9)
						.blur(radius: isAnimating ? 0 : 10)
						.opacity(isAnimating ? 1 : 0)
						.scaleEffect(isAnimating ? 1 : 0.5)
						.animation(.easeOut(duration: 1), value: isAnimating)
						.offset(y: isAnimating ? 0 : -40)
						.onAppear(perform: {
							isAnimating = true
						})
					
					Spacer()
					
					Text("Welcome to Unitopia!")
						.multilineTextAlignment(.center)
						.font(.largeTitle).bold()
						.blur(radius: isAnimating ? 0 : 10)
						.opacity(isAnimating ? 1 : 0)
						.scaleEffect(isAnimating ? 1 : 0.5)
						.animation(.easeOut(duration: 1.25), value: isAnimating)
						.offset(y: isAnimating ? 0 : -40)
						.onAppear(perform: {
							isAnimating = true
						})
					
					Spacer()
					
					ForEach(features) { feature in
						HStack {
							Image(systemName: feature.image)
								.frame(width: 44)
								.font(.title)
								.foregroundStyle(.blue)
								.accessibilityHidden(true)
							
							VStack(alignment: .leading) {
								Text(feature.title)
									.font(.headline)
								
								Text(feature.description)
									.foregroundStyle(.secondary)
							}
							.accessibilityElement(children: .combine)
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						.blur(radius: isAnimating ? 0 : 10)
						.opacity(isAnimating ? 1 : 0)
						.scaleEffect(isAnimating ? 1 : 0.5)
						.animation(.easeOut(duration: 1.75), value: isAnimating)
						.onAppear(perform: {
							isAnimating = true
						})
					}
				}
			}
			
			Text("Get started by tapping the button below.")
				.foregroundStyle(.secondary)
				.blur(radius: isAnimating ? 0 : 10)
				.opacity(isAnimating ? 1 : 0)
				.scaleEffect(isAnimating ? 1 : 0.5)
				.animation(.easeOut(duration: 2), value: isAnimating)
				.offset(y: isAnimating ? 0 : 40)
				.onAppear(perform: {
					isAnimating = true
				})
			
			Button("Get Started") {
				// Mark that the user has seen this welcome screen
				hasSeenWelcome = true
				// Save the current version as seen
				lastSeenVersion = currentVersion
			}
			.frame(maxWidth: .infinity, minHeight: 44)
			.background(.blue)
			.foregroundStyle(.white)
			.clipShape(Capsule())
			.blur(radius: isAnimating ? 0 : 10)
			.opacity(isAnimating ? 1 : 0)
			.scaleEffect(isAnimating ? 1 : 0.5)
			.animation(.easeOut(duration: 2.5), value: isAnimating)
			.offset(y: isAnimating ? 0 : 40)
			.onAppear(perform: {
				isAnimating = true
			})
		}
		.padding()
	}
}

/// A preview provider for WelcomeScreenView.
///
/// This creates a preview with default values for the welcome screen.
#Preview {
	WelcomeScreenView(
		hasSeenWelcome: .constant(false),
		lastSeenVersion: .constant("")
	)
}
