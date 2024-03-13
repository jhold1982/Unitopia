//
//  ControlGroupView.swift
//  Unitopia
//
//  Created by Justin Hold on 11/14/23.
//

import SwiftUI

struct ControlGroupView: View {
    var body: some View {
		if #available(iOS 16.4, *) {
			ControlGroup {
				Text("Text 1")
				Button("Button Left") {}
				Button("Button Right") {}
			} label: {
				Label("Content", systemImage: "plus")
			}
			.controlGroupStyle(.menu)
		} else {
			ControlGroup {
				Text("Text 1")
				Button("Button Left") {}
				Button("Button Right") {}
			} label: {
				Label("Content", systemImage: "plus")
			}
		}
    }
}

#Preview {
    ControlGroupView()
}
