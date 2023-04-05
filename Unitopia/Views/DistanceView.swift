//
//  DistanceView.swift
//  Unitopia
//
//  Created by Justin Hold on 4/4/23.
//

import SwiftUI

struct DistanceView: View {
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
			.navigationTitle("🏃🏼‍♂️ Distance 📏")
			.navigationBarTitleDisplayMode(.inline)
		}
    }
}

struct DistanceView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceView()
    }
}
