//
//  HistoryItem.swift
//  Unitopia
//
//  Created by Justin Hold on 7/9/23.
//

import Foundation

struct HistoryItem: Identifiable {
	let id = UUID()
	let inputAmount: Double
	let inputUnit: Dimension
	let outputUnit: Dimension
	let outputResult: String
	
}
