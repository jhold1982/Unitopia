//
//  SplashView.swift
//  Unitopia
//
//  Created by Justin Hold on 4/14/23.
//

import SwiftUI

struct SplashView: View {
	@State private var isActive: Bool = false
    var body: some View {
		ZStack {
			if self.isActive {
				ContentView()
			} else {
				Rectangle()
					.background(Color.black)
				Image("Unitopia.png")
					.resizable()
					.scaledToFit()
					.frame(width: 300, height: 300)
				ProgressView()
			}
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
				withAnimation {
					self.isActive = true
				}
			}
		}
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
