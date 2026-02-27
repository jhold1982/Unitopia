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
                    if #available(iOS 17, *) {
                        Toggle(
                            isOn: $isDarkMode,
                            label: {
                                Label {
                                    Text(isDarkMode ? "Dark Mode" : "Light Mode")
                                } icon: {
                                    Image(systemName: isDarkMode ? "moon.fill" : "sun.min")
                                        .contentTransition(.symbolEffect(.replace))
                                }
                            }
                        )
                    } else {
                        Toggle(isDarkMode ? "Dark Mode" : "Light Mode", isOn: $isDarkMode)
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
