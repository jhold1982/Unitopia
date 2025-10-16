//
//  ResetButtonModel.swift
//  Unitopia
//
//  Created by Justin Hold on 11/2/23.
//

import Foundation
import SwiftUI

/// A custom button style that formats a button as a reset or delete action.
///
/// This style applies a red color with semibold, subheadline font to emphasize
/// destructive or reset actions. It also includes a pressed state with reduced opacity
/// to provide visual feedback when the button is tapped.
///
/// Example usage:
/// ```
/// Button("Reset Settings") {
///     // Reset action
/// }
/// .buttonStyle(ResetButtonModel())
/// ```
struct ResetButtonModel: ButtonStyle {
	/// Creates the view body for the button.
	///
	/// - Parameter configuration: The properties of the button, including whether it's pressed.
	/// - Returns: A view that represents the body of the styled button.
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.subheadline)
			.fontWeight(.semibold)
			.foregroundStyle(.red)
			.opacity(configuration.isPressed ? 0.5 : 1)
	}
}

