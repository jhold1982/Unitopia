//
//  TimeView.swift
//  Unitopia
//
//  Created by Justin Hold on 4/5/23.
//

import SwiftUI

struct TimeView: View {
    var body: some View {
		NavigationStack {
			Form {
				Section {
					//
				} header: {
					Text("Amount to convert")
						.foregroundColor(.primary)
				}
			}
			.padding()
			.scrollContentBackground(.hidden)
			.background(
				LinearGradient(
					gradient: Gradient(
						colors: [.cyan, .white]),
						startPoint: .topLeading,
						endPoint: .bottomTrailing
				)
				.ignoresSafeArea()
			)
			.navigationTitle("⏳ Time 🕰️")
			.navigationBarTitleDisplayMode(.inline)
		}
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView()
    }
}
