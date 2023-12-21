//
//  DropDownView.swift
//  Unitopia
//
//  Created by Justin Hold on 11/21/23.
//

import SwiftUI

struct DropDownView: View {
	
	// MARK: - VIEW PROPERTIES
	var hint: String
	var options: [String]
	var anchor: Anchor = .bottom
	var maxWidth: CGFloat = 180
	var cornerRadius: CGFloat = 15
	
	@Binding var selection: String?
	
	@State private var showOptions: Bool = false
	
	@Environment(\.colorScheme) private var scheme
	
	@SceneStorage("drop_down_index") private var index = 1000.0
	
	@State private var zIndex: Double = 1000.0
	
	enum Anchor {
		case top
		case bottom
	}
	
	
	// MARK: - VIEW BODY
    var body: some View {
		GeometryReader {
			let size = $0.size
			
			VStack(spacing: 0) {
				
				if showOptions && anchor == .top {
					OptionsView()
				}
				HStack(spacing: 0) {
					Text(selection ?? hint)
						.foregroundStyle(selection == nil ? .gray : .primary)
						.lineLimit(1)
					
					Spacer(minLength: 0)
					
					Image(systemName: "chevron.down")
						.font(.title3)
						.foregroundStyle(.gray)
						.rotationEffect(.init(degrees: showOptions ? -180 : 0))
				}
				.padding(.horizontal, 15)
				.frame(width: size.width, height: size.height)
				.background(scheme == .dark ? .black : .white)
				.contentShape(.rect)
				.onTapGesture {
					index += 1
					zIndex = index
					withAnimation(.snappy) {
						showOptions.toggle()
					}
				}
				.zIndex(zIndex)
				
				if showOptions && anchor == .bottom {
					OptionsView()
				}
			}
			.clipped()
			.contentShape(.rect)
			.background(
				(scheme == .dark ? Color.black : Color.white).shadow(.drop(
					color: .primary.opacity(0.5),
					radius: 4)
				), in: .rect(cornerRadius: cornerRadius)
			)
			.frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
		}
		.frame(width: maxWidth, height: 50)
		.zIndex(zIndex)
    }
	
	// MARK: - METHODS
	@ViewBuilder
	func OptionsView() -> some View {
		VStack(spacing: 10) {
			ForEach(options, id: \.self) { option in
				HStack(spacing: 0) {
					Text(option)
						.lineLimit(1)
					
					Spacer(minLength: 0)
					
					Image(systemName: "checkmark")
						.font(.caption)
						.opacity(selection == option ? 1 : 0)
				}
				.foregroundStyle(selection == option ? Color.primary : Color.gray)
				.animation(.none, value: selection)
				.frame(height: 40)
				.contentShape(.rect)
				.onTapGesture {
					withAnimation(.snappy) {
						selection = option
						showOptions = false
					}
				}
			}
		}
		.padding(.horizontal, 15)
		.padding(.vertical, 5)
		.transition(.move(edge: anchor == .top ? .bottom : .top))
	}
}

#Preview {
    TestView()
}
