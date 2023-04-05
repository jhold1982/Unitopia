//
//  HomeView.swift
//  Unitopia
//
//  Created by Justin Hold on 4/4/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
		NavigationStack {
			ZStack {
				LinearGradient(
					gradient: Gradient(
						colors: [.cyan, .white]),
						startPoint: .topLeading,
						endPoint: .bottomTrailing
				)
					.ignoresSafeArea()
				VStack(spacing: 15) {
					Image("example")
						.resizable()
						.scaledToFit()
						.padding()
					HStack(spacing: 30) {
						Rectangle()
							.fill(Color.secondary).opacity(10)
							.frame(width: 175, height: 175)
						Rectangle()
							.fill(Color.secondary)
							.frame(width: 175, height: 175)
					}
					.padding(5)
					HStack(spacing: 30) {
						Rectangle()
							.fill(Color.secondary)
							.frame(width: 175, height: 175)
						Rectangle()
							.fill(Color.secondary)
							.frame(width: 175, height: 175)
					}
					.padding(5)
					Spacer()
				}
				.padding()
			}
			.navigationTitle("Unitopia")
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
