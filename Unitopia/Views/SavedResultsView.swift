//
//  SavedResultsView.swift
//  Unitopia
//
//  Created by Justin Hold on 5/8/23.
//

import SwiftUI

struct SavedResultsView: View {
    var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(
				colors: [.indigo, .gray, .white, .white]),
					startPoint: .topLeading,
					endPoint: .bottomTrailing
				)
				.ignoresSafeArea()
			Text("Saved Results")
		}
    }
}

struct SavedResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedResultsView()
    }
}
