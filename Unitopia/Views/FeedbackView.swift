//
//  FeedbackView.swift
//  Unitopia
//
//  Created by Justin Hold on 4/14/23.
//

import SwiftUI
import StoreKit

struct FeedbackView: View {
	
	// MARK: - PROPERTIES
	@State private var showingAlert = false
	
	
	// MARK: - VIEW BODY
	var body: some View {
		ZStack {
			
			VStack {
				Text("Enjoying Unitopia so far?")
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
				} //: END OF ALERT
			} //: END OF VSTACK
		} //: END OF ZSTACK
	}
}

// MARK: - PREVIEWS
struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
