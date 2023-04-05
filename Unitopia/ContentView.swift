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
			TemperatureView()
				.tabItem {
					Label("Temperature", systemImage: "thermometer")
				}
				.tag(1)
			DistanceView()
				.tabItem {
					Label("Distance", systemImage: "ruler")
				}
				.tag(2)
			MassView()
				.tabItem {
					Label("Mass", systemImage: "scalemass")
				}
				.tag(3)
			TimeView()
				.tabItem {
					Label("Time", systemImage: "clock.arrow.2.circlepath")
				}
		}
		.preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
