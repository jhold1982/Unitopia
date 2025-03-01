//
//  ReviewManager.swift
//  Unitopia
//
//  Created by Justin Hold on 10/30/23.
//

import Foundation
import StoreKit
import CoreSpotlight

/// A manager class that handles requesting app reviews from users.
///
/// This class is responsible for tracking app launches and requesting reviews
/// at appropriate times based on the number of app launches.
class ReviewManager: ObservableObject {
	
	/// Requests an app review from the user when appropriate conditions are met.
	///
	/// This method tracks the number of times the app has been launched using UserDefaults.
	/// When the launch count reaches or exceeds 3, it will request a review from the user
	/// and reset the launch count. Otherwise, it increments the launch count.
	///
	/// The review request is only shown if there is an active window scene in the foreground.
	///
	/// - Note: Apple may throttle review requests regardless of how often this method is called.
	/// Which is completely fucking retarted but what do I know? Praise Kier! 
	func requestReview() {
		let allScenes = UIApplication.shared.connectedScenes
		let scene = allScenes.first { $0.activationState == .foregroundActive }
		var launchCount = UserDefaults.standard.integer(forKey: "launchCount")
		if launchCount >= 3 {
			if let windowScene = scene as? UIWindowScene {
				SKStoreReviewController.requestReview(in: windowScene)
				launchCount = 0
			}
		} else {
			launchCount += 1
		}
		UserDefaults.standard.set(launchCount, forKey: "launchCount")
		UserDefaults.standard.synchronize()
	}
}
