//
//  ContentView.swift
//  Unitopia
//
//  Created by Justin Hold on 3/30/23.
//

import SwiftUI

struct ContentView: View {
	@State private var tabSelection = 0
    var body: some View {
		TabView(selection: $tabSelection) {
			HomeView()
				.tabItem {
					Label("Home", systemImage: "house")
				}
				.tag(0)
			FeedbackView()
				.tabItem {
					Label("Feedback", systemImage: "person.wave.2.fill")
				}
				.tag(1)
		}
		.preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
