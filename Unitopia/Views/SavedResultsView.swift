//
//  SavedResultsView.swift
//  Unitopia
//
//  Created by Justin Hold on 5/8/23.
//

import SwiftUI

struct SavedResultsView: View {
	
	// MARK: - PROPERTIES
	
	
	
	// MARK: - VIEW BODY
    var body: some View {
		NavigationStack {
			List {
//				Text("Input Amount: \(item.inputAmount, specifier: "%.2f")")
//				Text("Conversion Types: \(item.inputUnit.symbol) to \(item.outputUnit.symbol)")
//				Text("Output Result: \(item.outputResult)")
			}
			.navigationTitle("Saved Results")
			.navigationBarTitleDisplayMode(.inline)
			
			
		} //: END OF NAVIGATION STACK
    } //: END OF VIEW BODY
	
	// MARK: - FUNCTIONS
	
}

// MARK: - PREVIEWS
struct SavedResultsView_Previews: PreviewProvider {
    static var previews: some View {
		SavedResultsView()
    }
}
