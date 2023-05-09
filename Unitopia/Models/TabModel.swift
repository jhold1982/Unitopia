//
//  TabModel.swift
//  Unitopia
//
//  Created by Justin Hold on 5/8/23.
//

import Foundation
import SwiftUI

enum Tab: String, CaseIterable {
	case home = "Home"
	case saved = "Saved"
	case feedback = "Feedback"
	case settings = "Settings"
	
	var systemImage: String {
		switch self {
		case .home:
			return "house"
		case .saved:
			return "square.and.arrow.down"
		case .feedback:
			return "person.wave.2.fill"
		case .settings:
			return "gearshape"
		}
	}
	
	var index: Int {
		return Tab.allCases.firstIndex(of: self) ?? 0
	}
}
