//
//  ContentView.swift
//  Unitopia
//
//  Created by Justin Hold on 3/30/23.
//

import SwiftUI

struct ContentView: View {
	
	// MARK: - VIEW PROPERTIES
	@EnvironmentObject var dataController: DataController
	
	
	// MARK: - VIEW BODY
    var body: some View {
		ConversionView()
    }
}

// MARK: - PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
