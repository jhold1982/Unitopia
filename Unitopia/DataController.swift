//
//  DataController.swift
//  Unitopia
//
//  Created by Justin Hold on 10/30/23.
//

import Foundation
import SwiftUI
import StoreKit
import CoreSpotlight

class DataController: ObservableObject {
	
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
