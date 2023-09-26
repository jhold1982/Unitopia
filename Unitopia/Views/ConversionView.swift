//
//  ConversionView.swift
//  Unitopia
//
//  Created by Justin Hold on 9/17/23.
//

import SwiftUI

struct ConversionView: View {
	
	@State private var input = 0.0
	@State private var selectedUnits = 0
	
	@State private var inputUnit: Dimension = UnitTemperature.fahrenheit
	@State private var outputUnit: Dimension = UnitTemperature.celsius
	
	@FocusState private var userInputIsFocused: Bool
	
	let formatter: MeasurementFormatter
	
	init() {
		formatter = MeasurementFormatter()
		formatter.unitOptions = .providedUnit
		formatter.unitStyle = .short
		
		// Large Navigation Title
		UINavigationBar.appearance().largeTitleTextAttributes = [
			.foregroundColor: UIColor.creamyWhite
		]
		// Inline Navigation Title
		UINavigationBar.appearance().titleTextAttributes = [
			.foregroundColor: UIColor.creamyWhite
		]
	}
	
	let conversionTypes = [
		"Temperature",
		"Distance",
		"Mass",
		"Time",
		"Speed"
	]
	
	let unitTypes = [
		[
			UnitTemperature.fahrenheit,
			UnitTemperature.celsius, 
			UnitTemperature.kelvin
		],
		[
			UnitLength.inches,
			UnitLength.feet,
			UnitLength.meters,
			UnitLength.miles,
			UnitLength.kilometers
		],
		[
			UnitMass.grams,
			UnitMass.kilograms,
			UnitMass.pounds,
			UnitMass.ounces
		],
		[
			UnitDuration.hours,
			UnitDuration.minutes,
			UnitDuration.seconds
		],
		[
			UnitSpeed.milesPerHour,
			UnitSpeed.kilometersPerHour,
			UnitSpeed.metersPerSecond
		]
	]
	
	let darkGrayBackground = Color("darkGrayBackground")
	let creamyWhite = Color("creamyWhite")
	let lightLightGray = Color("lightLightGray")
	let darkBlack = Color("darkBlack")
	
	var result: String {
		let inputMeasurement = Measurement(value: input, unit: inputUnit)
		let outputMeasurement = inputMeasurement.converted(to: outputUnit)
		return formatter.string(from: outputMeasurement)
	}
	
    var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Enter amount to convert...", value: $input, format: .number)
						.keyboardType(.decimalPad)
						.focused($userInputIsFocused)
				} header: {
					Text("Amount to convert")
						.font(.subheadline.bold())
				}
				.listRowBackground(Color.darkGrayBackground)
				
				Picker("Coversion", selection: $selectedUnits) {
					ForEach(0..<conversionTypes.count, id: \.self) {
						Text(conversionTypes[$0])
							
					}
				}
				.tint(.creamyWhite)
				.listRowBackground(Color.darkGrayBackground)
				
				Picker("Convert from:", selection: $inputUnit) {
					ForEach(unitTypes[selectedUnits], id: \.self) {
						Text(formatter.string(from: $0).capitalized)
					}
				}
				.tint(.creamyWhite)
				.listRowBackground(Color.darkGrayBackground)
				
				Picker("Convert to:", selection: $outputUnit) {
					ForEach(unitTypes[selectedUnits], id: \.self) {
						Text(formatter.string(from: $0).capitalized)
					}
				}
				.tint(.creamyWhite)
				.listRowBackground(Color.darkGrayBackground)
				
				Section {
					Text(result)
				} header: {
					Text("Result")
						.font(.subheadline.bold())
				}
				.listRowBackground(Color.darkGrayBackground)
				
				Button("Reset") {
					reset()
				}
				.listRowBackground(Color.darkGrayBackground)
				
			}
			.navigationTitle("Unitopia")
			.background(.darkBlack)
			.foregroundStyle(.creamyWhite)
			.scrollContentBackground(.hidden)
			.toolbar {
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()
					Button("Done") {
						userInputIsFocused = false
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
	
	func reset() {
		input = 0.0
		selectedUnits = 0
	}
}

struct ConversionView_Previews: PreviewProvider {
    static var previews: some View {
		ConversionView()
    }
}
