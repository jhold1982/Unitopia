//
//  Store.swift
//  Unitopia
//
//  Created by Justin Hold on 8/10/23.
//

import Foundation
import SwiftUI

class Store: ObservableObject {
//	let isPro: Bool
//	let isStandard: Bool
//
//	init(isPro: Bool, isStandard: Bool) {
//		self.isPro = isPro
//		self.isStandard = isStandard
//	}
	var name: String
	
	init(name: String) {
		self.name = name
	}
}
