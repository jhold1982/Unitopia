//
//  HomeView.swift
//  Unitopia
//
//  Created by Justin Hold on 4/4/23.
//

import SwiftUI

struct HomeView: View {
	
	// MARK: - PROPERTIES
	@State private var input: Double = 0.0
	@State private var selectedUnits = 0
	@State private var inputUnit: Dimension = UnitTemperature.celsius
	@State private var outputUnit: Dimension = UnitTemperature.fahrenheit
	
	
	@FocusState private var inputIsFocused: Bool
	
	let formatter: MeasurementFormatter
	let conversionTypes = ["Temperature", "Distance", "Mass", "Time", "Speed"]
	let unitTypes = [
		[
			UnitTemperature.fahrenheit,
			UnitTemperature.celsius,
			UnitTemperature.kelvin
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
		],
		[
			UnitDuration.hours,
			UnitDuration.minutes,
			UnitDuration.seconds
		],
		[
			UnitSpeed.milesPerHour,
			UnitSpeed.kilometersPerHour
		]
	]
	
	var result: String {
		let inputMeasurement = Measurement(value: input, unit: inputUnit)
		let outputMeasurement = inputMeasurement.converted(to: outputUnit)
		return formatter.string(from: outputMeasurement)
	}
	
	// MARK: - FORMAT INITIALIZER
	init() {
		formatter = MeasurementFormatter()
		formatter.unitOptions = .providedUnit
		formatter.unitStyle = .short
	}
	
	// MARK: - VIEW BODY
    var body: some View {
		NavigationStack {
			Form {
				// MARK: - HEADER
				Section {
					TextField("Enter an amount", value: $input, format: .number)
						.keyboardType(.decimalPad)
						.focused($inputIsFocused)
				} header: {
					Text("Amount to convert")
						.foregroundColor(.primary)
						.font(.subheadline.bold())
				}
				
				// MARK: - CENTER PICKERS
				Picker("Conversion", selection: $selectedUnits) {
					ForEach(0..<conversionTypes.count, id: \.self) {
						Text(conversionTypes[$0])
					}
				}
				.pickerStyle(.menu)
				
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
				
				// MARK: - FOOTER
				Section {
					Text(result)
				} header: {
					Text("Result")
						.foregroundColor(.primary)
						.font(.subheadline.bold())
				}
				Button("Reset") {
					reset()
				} //: END OF RESET BUTTON
				.foregroundColor(.red)
			} //: END OF FORM
			.navigationTitle("Unitopia")
			.toolbar {
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()
					Button("Done") {
					inputIsFocused = false
					}
				}
			} //: END OF TOOLBAR
			.onChange(of: selectedUnits) { newSelection in
				let units = unitTypes[newSelection]
				inputUnit = units[0]
				outputUnit = units[1]
			} //: END OF ON CHANGE
		}
    }
	
	// MARK: - FUNCTIONS
	func reset() {
		input = 0.0
		selectedUnits = 0
	}
}

// MARK: - PREVIEWS
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
