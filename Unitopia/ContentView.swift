//
//  ContentView.swift
//  Unitopia
//
//  Created by Justin Hold on 3/30/23.
//

import SwiftUI

struct ContentView: View {
	
	// MARK: - PROPERTIES
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
    } //: END OF VIEW BODY
}

// MARK: - PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
