//
//  TimeView.swift
//  Unitopia
//
//  Created by Justin Hold on 4/5/23.
//

import SwiftUI

struct TimeView: View {
	@State private var input = 0.0
	@State private var selectedUnits = 0
	@State private var inputUnit: Dimension = UnitDuration.hours
	@State private var outputUnit: Dimension = UnitDuration.seconds
	@FocusState private var inputIsFocused: Bool
	let formatter: MeasurementFormatter
	let conversions = ["Duration"]
	let unitTypes = [
		[
			UnitDuration.hours,
			UnitDuration.minutes,
			UnitDuration.seconds
		],

		[
			UnitLength.feet,
			UnitLength.kilometers,
			UnitLength.meters,
			UnitLength.miles,
			UnitLength.yards
		],

		[
			UnitMass.grams,
			UnitMass.kilograms,
			UnitMass.ounces,
			UnitMass.pounds
		]
	]
	var result: String {
		let inputMeasurement = Measurement(value: input, unit: inputUnit)
		let outputMeasurement = inputMeasurement.converted(to: outputUnit)
		return formatter.string(from: outputMeasurement)
	}
    var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Amount", value: $input, format: .number)
						.keyboardType(.decimalPad)
						.focused($inputIsFocused)
				} header: {
					Text("Amount to convert")
						.foregroundColor(.primary)
						.font(.subheadline.bold())
				}
//				Picker("Conversion", selection: $selectedUnits) {
//					ForEach(0..<conversions.count, id: \.self) {
//						Text(conversions[$0])
//					}
//				}
//				.pickerStyle(.menu)
				Picker("Convert from:", selection: $inputUnit) {
					ForEach(unitTypes[selectedUnits], id: \.self) {
						Text(formatter.string(from: $0).capitalized)
					}
				}
				.pickerStyle(.menu)
				Picker("Convert to:", selection: $outputUnit) {
					ForEach(unitTypes[selectedUnits], id: \.self) {
						Text(formatter.string(from: $0).capitalized)
					}
				}
				.pickerStyle(.menu)
				Section {
					Text(result)
				} header: {
					Text("Result")
						.foregroundColor(.primary)
						.font(.subheadline.bold())
				}
				Button("Save") { }
				/// Add list style save for temp amounts with forEach and onDelete up to 5 or 6 rows to be saved
			}
			.padding()
			.scrollContentBackground(.hidden)
			.background(
				LinearGradient(
					gradient: Gradient(
						colors: [.cyan, .white]),
						startPoint: .topLeading,
						endPoint: .bottomTrailing
				)
				.ignoresSafeArea()
			)
			.navigationTitle("⏳ Time 🕰️")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem {
					Button("Reset", action: reset)
						.foregroundColor(Color.red)
						.font(.headline.bold())
						.padding()
				}
			}
			.toolbar {
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()
					Button("Done") {
					inputIsFocused = false
					}
				}
			}
			.onChange(of: selectedUnits) { newSelection in
				let units = unitTypes[newSelection]
				inputUnit = units[0]
				outputUnit = units[1]
			}
		}
    }
	init() {
		formatter = MeasurementFormatter()
		formatter.unitOptions = .providedUnit
		formatter.unitStyle = .short
	}
	func reset() {
		input = 0.0
		selectedUnits = 0
		/// delete all rows
	}
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView()
    }
}
