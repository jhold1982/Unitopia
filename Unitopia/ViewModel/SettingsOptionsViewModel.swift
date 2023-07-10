//
//  SettingsOptionsViewModel.swift
//  Unitopia
//
//  Created by Justin Hold on 7/10/23.
//

import Foundation
import SwiftUI

enum SettingsOptionsViewModel: Int, CaseIterable, Identifiable {
	case darkMode
	case activeStatus
	case accessibility
	case privacy
	case notifications
	
	var title: String {
		switch self {
		case .darkMode:
			return "Dark mode"
		case .activeStatus:
			return "Active status"
		case .accessibility:
			return "Accessbility"
		case .privacy:
			return "Privacy and Safety"
		case .notifications:
			return "Notifications"
		}
	}
	
	var imageName: String {
		switch self {
		case .darkMode:
			return "moon.circle.fill"
		case .activeStatus:
			return "message.badge.circle.fill"
		case .accessibility:
			return "person.circle.fill"
		case .privacy:
			return "lock.circle.fill"
		case .notifications:
			return "bell.circle.fill"
		}
	}
	
	var imageBackgroundColor: Color {
		switch self {
		case .darkMode:
			return .black
		case .activeStatus:
			return .green
		case .accessibility:
			return .blue
		case .privacy:
			return .purple
		case .notifications:
			return .red
		}
	}
	
	var id: Int { return self.rawValue }
}
