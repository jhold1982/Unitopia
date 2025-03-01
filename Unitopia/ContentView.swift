//
//  ContentView.swift
//  Unitopia
//
//  Created by Justin Hold on 9/17/23.
//

import SwiftUI
import StoreKit
import CoreSpotlight

struct ContentView: View {
	
	// MARK: - Properies
	@State private var input = 0.0
	@State private var selectedUnits = 0
	
	@State private var showResetAlert: Bool = false
	
	@State private var inputUnit: Dimension = UnitTemperature.fahrenheit
	@State private var outputUnit: Dimension = UnitTemperature.celsius
	
	@State private var selection: String?
	
	@Environment(\.requestReview) private var requestReview
	
	@EnvironmentObject var dataController: ReviewManager
	
	@AppStorage("isDarkMode") private var isDarkMode = false
	@AppStorage("processCompletedCount") var processCompletedCount = 0
	@AppStorage("currentAppVersion") var currentAppVersion = "1.2.2"
	@AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview = "1.2.2"
	
	@FocusState private var userInputIsFocused: Bool
	
	let formatter: MeasurementFormatter
	
	let conversionTypes = [
		"Temperature",
		"Distance",
		"Mass",
		"Time",
		"Speed",
		"Volume"
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
		],
		[
			UnitVolume.liters,
			UnitVolume.gallons,
			UnitVolume.acreFeet,
			UnitVolume.bushels,
			UnitVolume.pints,
			UnitVolume.quarts,
			UnitVolume.fluidOunces,
			UnitVolume.centiliters,
			UnitVolume.milliliters,
			UnitVolume.cups
		]
	]
	
	// MARK: - Custom Colors (not used)
	let darkGrayBackground = Color("darkGrayBackground")
	let creamyWhite = Color("creamyWhite")
	let lightLightGray = Color("lightLightGray")
	let darkBlack = Color("darkBlack")
	
	var result: String {
		let inputMeasurement = Measurement(value: input, unit: inputUnit)
		let outputMeasurement = inputMeasurement.converted(to: outputUnit)
		return formatter.string(from: outputMeasurement)
	}
	
	init() {
		formatter = MeasurementFormatter()
		formatter.unitOptions = .providedUnit
		formatter.unitStyle = .short
	}
	
	// MARK: - View Body
    var body: some View {
		NavigationStack {
			
			if #available(iOS 17.0, *) {
				Form {
					
					// MARK: - Conversion
					Section {
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
						
					} header: {
						Text("")
					}
					
					// MARK: - User Input
					Section {
						TextField("Enter an amount...", value: $input, format: .number)
							.keyboardType(.decimalPad)
							.focused($userInputIsFocused)
					} header: {
						Text("Amount to convert")
							.font(.subheadline.bold())
					}
					
					// MARK: - Result
					Section {
						if userInputIsFocused {
							Text("--")
						} else if input == 0 {
							Text("--")
						} else {
							Text(result)
						}
					} header: {
						Text("Result")
							.font(.subheadline.bold())
					}
					
					Button("Start Over") {
						showResetAlert = true
					}
					.buttonStyle(ResetButtonModel())
					.disabled(input == 0)
					.opacity(input == 0 ? 0.5 : 1)

					// iOS 17 check for sf symbol animation
					if #available(iOS 17, *) {
						Toggle(
							isOn: $isDarkMode,
							label: {
								Label(
									title: { Text("") },
									icon: {
										Image(systemName: isDarkMode ? "moon.fill" : "sun.min")
											.contentTransition(.symbolEffect(.replace))
									}
								)
							}
						)
						.foregroundStyle(!isDarkMode ? Color.primary : Color.white)
					} else {
						Toggle(isDarkMode ? "Dark Mode" : "Light Mode", isOn: $isDarkMode)
					}
					
				}
				.navigationTitle("Unitopia")
				.toolbar {
					ToolbarItemGroup(placement: .keyboard) {
						Spacer()
						Button("Done") {
							userInputIsFocused = false
						}
					}
				}
				.onChange(of: selectedUnits) {
					let units = unitTypes[selectedUnits]
					inputUnit = units[0]
					outputUnit = units[1]
				}
				.alert(isPresented: $showResetAlert) {
					Alert(
						title: Text("Skibiddi Rizz?"),
						message: Text("This will sigma all gyatts to their default auras."),
						primaryButton: .default(Text("Reset")) {
							reset()
						},
						secondaryButton: .cancel(Text("Cancel"))
					)
				}
			}
		}
    }

	func reset() {
		input = 0.0
		selectedUnits = 0
		processCompletedCount += 1
		experiencedReview()
	}
	
	func experiencedReview() {
		if processCompletedCount >= 3, currentAppVersion != lastVersionPromptedForReview {
			presentReview()
			
			lastVersionPromptedForReview = currentAppVersion
		}
	}
	
	func presentReview() {
		Task {
			try await Task.sleep(for: .seconds(2))
			requestReview()
		}
	}
}

// MARK: - Previews
struct ConversionView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			
    }
}
