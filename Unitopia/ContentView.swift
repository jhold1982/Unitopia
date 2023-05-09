//
//  ContentView.swift
//  Unitopia
//
//  Created by Justin Hold on 3/30/23.
//

import SwiftUI

struct ContentView: View {
	@State private var activeTab: Tab = .home
	@State private var tabShapePosition: CGPoint = .zero
	// Using MatchedGeometry for smooth sliding shape effect
	@Namespace private var animation
	// Hiding Tab Bar due to iOS 16 Bug (moving tabs pushes view upwards)
	init() {
		UITabBar.appearance().isHidden = true
	}
    var body: some View {
		VStack(spacing: 0) {
			TabView(selection: $activeTab) {
				HomeView()
					.tag(Tab.home)
					
				SavedResultsView()
					.tag(Tab.saved)
					
				FeedbackView()
					.tag(Tab.feedback)
					
				SettingsView()
					.tag(Tab.settings)
			}
			.preferredColorScheme(.light)
			customTabBar()
		}
    }
	// Custom Tab Bar
	@ViewBuilder
	func customTabBar(_ tint: Color = .indigo, _ inactiveTint: Color = .gray) -> some View {
		// Pushing remaining Tab Items further down
		HStack(alignment: .bottom, spacing: 0) {
			ForEach(Tab.allCases, id: \.rawValue) {
				TabBarItem(
					tint: tint,
					inactiveTint: inactiveTint,
					tab: $0,
					animation: animation,
					activeTab: $activeTab,
					position: $tabShapePosition
				)
			}
		}
		.padding(.horizontal, 15)
		.padding(.vertical, 10)
		.background {
			TabShape(midPoint: tabShapePosition.x)
				.fill(.white)
				.ignoresSafeArea()
				// Adding Blur + Shadow for shape smoothing
				.shadow(
					color: tint.opacity(0.2),
					radius: 5,
					x: 0,
					y: -5
				)
				.blur(radius: 2)
				.padding(.top, 25)
		}
		// Adding Animation
		.animation(.interactiveSpring(
			response: 0.6,
			dampingFraction: 0.7,
			blendDuration: 0.7
		), value: activeTab)
	}
}

// Tab Bar Item
struct TabBarItem: View {
	var tint: Color
	var inactiveTint: Color
	var tab: Tab
	var animation: Namespace.ID
	@Binding var activeTab: Tab
	@Binding var position: CGPoint
	// Each Tab position on screen
	@State private var tabPosition: CGPoint = .zero
	var body: some View {
		VStack(spacing: 5) {
			Image(systemName: tab.systemImage)
				.font(.title2)
				.foregroundColor(activeTab == tab ? .white : inactiveTint)
				// Increasing size for active tab
				.frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
				.background {
					if activeTab == tab {
						Circle()
							.fill(tint.gradient)
							.matchedGeometryEffect(id: "ACTIVETAB", in: animation)
					}
				}
			Text(tab.rawValue)
				.font(.caption)
				.foregroundColor(activeTab == tab ? tint : .gray)
		}
		.frame(maxWidth: .infinity)
		.contentShape(Rectangle())
		.viewPosition(completion: { rect in
			tabPosition.x = rect.midX
			// Updating active tab position
			if activeTab == tab {
				position.x = rect.midX
			}
		})
		.onTapGesture {
			activeTab = tab
			withAnimation(.interactiveSpring(
				response: 0.6,
				dampingFraction: 0.7,
				blendDuration: 0.7
			)) {
				position.x = tabPosition.x
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
