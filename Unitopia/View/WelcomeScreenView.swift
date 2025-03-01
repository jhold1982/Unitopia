//
//  WelcomeScreenView.swift
//  Unitopia
//
//  Created by Justin Hold on 2/28/25.
//

import SwiftUI

struct WelcomeScreenView: View {
	
	// MARK: - Properties
	@Environment(\.dismiss) var dismiss
	
	let features = [
		
		Feature(
			title: "Comprehensive Unit Conversion",
			description: "Convert between hundreds of units across multiple categories including length, weight, volume, temperature, and time with precise, accurate results.",
			image: "pencil"
		),
		
		Feature(
			title: "",
			description: "",
			image: "sun.max"
		),
		
		Feature(
			title: "Offline Functionality",
			description: "Convert between units without an internet connection.",
			image: "keyboard"
		)
	]
	
	// MARK: - View Body
    var body: some View {
        
		VStack(spacing: 20) {
			
			ScrollView {
				VStack(spacing: 20) {
					
					Image("unitopiaIcon")
						.resizable()
						.scaledToFit()
						.frame(width: 144, height: 144)
						.clipShape(Circle())
					
					Spacer()
					
					Text("Welcome to Unitopia!")
						.multilineTextAlignment(.center)
						.font(.largeTitle).bold()
					
					Spacer()
					
					ForEach(features) { feature in
						HStack {
							Image(systemName: feature.image)
								.frame(width: 44)
								.font(.title)
								.foregroundStyle(.blue)
								.accessibilityHidden(true)
							
							VStack(alignment: .leading) {
								Text(feature.title)
									.font(.headline)
								
								Text(feature.description)
									.foregroundStyle(.secondary)
							}
							.accessibilityElement(children: .combine)
						}
						.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
			}
			
			Text("Get started by tapping the button below.")
				.foregroundStyle(.secondary)
			
			Button("Get Started") {
				dismiss()
			}
			.frame(maxWidth: .infinity, minHeight: 44)
			.background(.blue)
			.foregroundStyle(.white)
			.clipShape(Capsule())
		}
		.padding()
    }
}

#Preview {
    WelcomeScreenView()
}
