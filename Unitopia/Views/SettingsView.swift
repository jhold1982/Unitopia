//
//  SettingsView.swift
//  Unitopia
//
//  Created by Justin Hold on 5/8/23.
//

import SwiftUI

struct SettingsView: View {
	
	// MARK: - PROPERTIES
	@State private var testSelection = false
	@State private var darkModeEnabled = false
	
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - VIEW BODY
    var body: some View {
		NavigationStack {
			// MARK: - LIST
			List {
				Section {
					ForEach(SettingsOptionsViewModel.allCases) { option in
						HStack {
							Image(systemName: option.imageName)
								.resizable()
								.frame(width: 24, height: 24)
								.foregroundColor(option.imageBackgroundColor)
							Text(option.title)
								.font(.subheadline)
						}
					}
				} //: END OF TOP SECTION
			} //: END OF LIST
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.inline)
		} //: END OF NAVIGATION STACK
    }
	// MARK: - FUNCTIONS
	func toggleColorScheme() {
		if colorScheme == .light {
			//
		} else {
			//
		}
	}
}

// MARK: - PREVIEWS
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

// HAVE SETTING / TOGGLE BUTTON FOR DARK MODE, CLEAR SAVED RESULTS, CHANGE APP ICON?
