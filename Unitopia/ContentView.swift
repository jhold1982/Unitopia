//
//  ContentView.swift
//  Unitopia
//
//  Created by Justin Hold on 3/30/23.
//

import SwiftUI

struct ContentView: View {
	
	// MARK: - Properties
	@EnvironmentObject var reviewManager: ReviewManager
	
	
	// MARK: - View Body
    var body: some View {
		ConversionView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
