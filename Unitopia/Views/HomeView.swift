//
//  HomeView.swift
//  Unitopia
//
//  Created by Justin Hold on 4/4/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
		NavigationStack {
			ZStack {
				Text("Home")
			}
			.navigationTitle("Unitopia")
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
