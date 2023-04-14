//
//  FeedbackView.swift
//  Unitopia
//
//  Created by Justin Hold on 4/14/23.
//

import SwiftUI
import StoreKit

struct FeedbackView: View {
	@State private var showingAlert = false
	var body: some View {
		ZStack {
			LinearGradient(
				gradient: Gradient(
					colors: [.cyan, .white]),
					startPoint: .topLeading,
					endPoint: .bottomTrailing
			)
				.ignoresSafeArea()
			VStack {
				Text("Enjoying the app?")
					.font(.title)
					.padding()

				Button(action: {
					showingAlert.toggle()
				}) {
					Text("Leave a Review")
						.padding()
						.foregroundColor(.white)
						.background(Color.blue)
						.cornerRadius(10)
				}
				.alert(isPresented: $showingAlert) {
					let message = "If you enjoy using this app, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!"
					return Alert(
						title: Text("Rate this App"),
						message: Text(message),
						primaryButton: .default(Text("Rate Now"), action: {
							if let writeReviewURL = URL(string: "https://itunes.apple.com/app/idYOUR_APP_ID?action=write-review") {
								UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
							}
						}),
						secondaryButton: .cancel()
					)
				}
			}
		}
	}
}


struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
