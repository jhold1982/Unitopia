//
//  ContentView.swift
//  Unitopia
//
//  Created by Justin Hold on 3/30/23.
//

import SwiftUI

struct ContentView: View {
	
	// MARK: - PROPERTIES
//	@ObservedObject var store: Store<AppState, AppAction>
	
	@Environment(\.requestReview) private var requestReview
	@Environment(\.scenePhase) private var scenePhase
	
	@AppStorage("launches") private var launches = 0
	
	@SceneStorage("paywall") private var paywallShown = false
	@SceneStorage("onboarding") private var onboardingShown = false
	
	@State private var activeTab = 0
	
	
	// MARK: - VIEW BODY
    var body: some View {
		
		TabView(selection: $activeTab) {
			HomeView()
				.tabItem {
					Label("Conversions", systemImage: "gyroscope")
				}
				.tag(0)

			SavedResultsView()
				.tabItem {
					Label("Saved", systemImage: "square.and.arrow.down")
				}
				.tag(1)

			FeedbackView()
				.tabItem {
					Label("Feedback", systemImage: "scroll")
				}
				.tag(2)

			SettingsView()
				.tabItem {
					Label("Settings", systemImage: "gearshape")
				}
				.tag(3)
		} //: END OF TABVIEW
		.sheet(isPresented: $paywallShown) {
			PaywallView()
		}
		.sheet(isPresented: $onboardingShown) {
			OnboardingView()
		}
		
//		.task(id: scenePhase) {
//			guard scenePhase == .active else {
//				return
//			}
//			await store.send(.fetchActiveTransactions)
//
//			if launches == 0 {
//				onboardingShown = true
//			} else {
//				let vote = Int.random(in: 1...3)
//
//				switch vote {
//				case 1:
//					requestReview()
//				case 2:
//					if !store.isPro {
//						paywallShown = true
//					}
//				default:
//					break
//				}
//			}
//			launches = 1
//		}
		
		
    } //: END OF VIEW BODY
	
}

// MARK: - PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
