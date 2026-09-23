//
//  SettingsView.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import SwiftUI

/// The Settings tab — appearance preferences and app information.
struct SettingsView: View {

    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Toggle(isOn: $isDarkMode) {
                        Label {
                            Text(isDarkMode ? "Dark Mode" : "Light Mode")
                        } icon: {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.min")
                                .contentTransition(.symbolEffect(.replace))
                        }
                    }
                }

                Section("About") {
                    LabeledContent("Version", value: Bundle.appVersion)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
