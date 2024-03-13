//
//  ResetButtonModel.swift
//  Unitopia
//
//  Created by Justin Hold on 11/2/23.
//

import Foundation
import SwiftUI

struct ResetButtonModel: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.subheadline)
			.fontWeight(.semibold)
			.foregroundStyle(.red)
			.opacity(configuration.isPressed ? 0.5 : 1)
	}
}

#Preview(body: {
	ConversionView()
})
