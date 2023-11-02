//
//  ConversionView.swift
//  Unitopia
//
//  Created by Justin Hold on 9/17/23.
//

import SwiftUI

struct ConversionView: View {
	
	// MARK: - VIEW PROPERTIES
	@State private var input = 0.0
	@State private var selectedUnits = 0
	@State private var inputUnit: Dimension = UnitTemperature.fahrenheit
	@State private var outputUnit: Dimension = UnitTemperature.celsius
	@EnvironmentObject var dataController: DataController
	@AppStorage("isDarkMode") private var isDarkMode = false
	@FocusState private var userInputIsFocused: Bool
	
	let formatter: MeasurementFormatter
	
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
			UnitLength.centimeters,
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
			UnitDuration.seconds,
			UnitDuration.milliseconds
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
	
	// MARK: - INITIALIZER
	init() {
		
		formatter = MeasurementFormatter()
		formatter.unitOptions = .providedUnit
		formatter.unitStyle = .short
		
		// MARK: - LARGE NAV TITLE
//		UINavigationBar.appearance().largeTitleTextAttributes = [
//			.foregroundColor: UIColor.creamyWhite
//		]
		// MARK: - INLINE NAV TITLE
//		UINavigationBar.appearance().titleTextAttributes = [
//			.foregroundColor: UIColor.creamyWhite
//		]
	}
	
	// MARK: - VIEW BODY
    var body: some View {
		NavigationStack {
			Form {
				Section {
					Picker("Conversion", selection: $selectedUnits) {
						ForEach(0..<conversionTypes.count, id: \.self) {
							Text(conversionTypes[$0])
						}
					}
					.pickerStyle(.menu)
//					.tint(.creamyWhite)
//					.listRowBackground(Color.darkGrayBackground)
					
					Picker("Convert from:", selection: $inputUnit) {
						ForEach(unitTypes[selectedUnits], id: \.self) {
							Text(formatter.string(from: $0).capitalized)
						}
					}
					.pickerStyle(.menu)
//					.tint(.creamyWhite)
//					.listRowBackground(Color.darkGrayBackground)
					
					Picker("Convert to:", selection: $outputUnit) {
						ForEach(unitTypes[selectedUnits], id: \.self) {
							Text(formatter.string(from: $0).capitalized)
						}
					}
					.pickerStyle(.menu)
//					.tint(.creamyWhite)
//					.listRowBackground(Color.darkGrayBackground)
				} header: {
					Text("")
						.font(.subheadline.bold())
				}
				
				Section {
					TextField("Enter an amount...", value: $input, format: .number)
						.keyboardType(.decimalPad)
						.focused($userInputIsFocused)
				} header: {
					Text("Amount to convert")
						.font(.subheadline.bold())
				}
//				.listRowBackground(Color.darkGrayBackground)
				
				Section {
					if userInputIsFocused {
						Text("")
					} else {
						Text(result)
					}
				} header: {
					Text("Result")
						.font(.subheadline.bold())
				}
//				.listRowBackground(Color.darkGrayBackground)
				
				Button("Reset") {
					reset()
				}
				.tint(.red)
//				.listRowBackground(Color.darkGrayBackground)
				
				// Put this in a tab of settings
				Toggle(isDarkMode ? "Light Mode" : "Dark Mode", isOn: $isDarkMode)
				
			}
			.navigationTitle("Unitopia")
//			.scrollContentBackground(.hidden)
//			.foregroundStyle(.creamyWhite)
//			.background(.darkBlack)
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
	// MARK: - METHODS
	/// Resets user inputted amounts for Input and Selected Units back to defaults
	func reset() {
		input = 0.0
		selectedUnits = 0
	}
}

// MARK: - PREVIEWS
struct ConversionView_Previews: PreviewProvider {
    static var previews: some View {
		ConversionView()
			
    }
}
