//
//  TestView.swift
//  Unitopia
//
//  Created by Justin Hold on 11/21/23.
//

import SwiftUI

struct TestView: View {
	@State private var selection: String?
	@State private var selection1: String?
	@State private var selection2: String?
    var body: some View {
		NavigationStack {
			VStack(spacing: 15) {
				DropDownView(
					hint: "Select",
					options: [
						"Test 1",
						"Test 2",
						"Test 3",
						"Test 4",
						"Test 5"
					],
					anchor: .bottom,
					selection: $selection
				)
				
				DropDownView(
					hint: "Select Me",
					options: [
						"Other 1",
						"Other 2",
						"Other 3"
					],
					anchor: .top,
					selection: $selection1
				)
			}
			.navigationTitle("Drop Down")
		}
    }
}

#Preview {
    TestView()
}
