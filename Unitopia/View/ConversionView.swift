//
//  ConversionView.swift
//  Unitopia
//
//  Created by Justin Hold on 9/17/23.
//

import SwiftUI
import StoreKit
import CoreSpotlight

struct ConversionView: View {
	
	// MARK: - VIEW PROPERTIES
	@State private var input = 0.0
	@State private var selectedUnits = 0
	
	@State private var showResetAlert: Bool = false
	
	@State private var inputUnit: Dimension = UnitTemperature.fahrenheit
	@State private var outputUnit: Dimension = UnitTemperature.celsius
	
	@State private var selection: String?
	
	@Environment(\.requestReview) private var requestReview
	
	@EnvironmentObject var dataController: DataController
	
	@AppStorage("isDarkMode") private var isDarkMode = false
	@AppStorage("processCompletedCount") var processCompletedCount = 0
	@AppStorage("currentAppVersion") var currentAppVersion = "1.2.1"
	@AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview = "1.2.1"
	
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
			UnitVolume.fluidOunces,
			UnitVolume.centiliters,
			UnitVolume.milliliters,
			UnitVolume.cups
		]
	]
	
	// MARK: - CUSTOM COLORS
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
			
			if #available(iOS 17.0, *) {
				Form {
					
					// MARK: - CONVERSION
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
					}
					
					// MARK: - USER INPUT
					Section {
						TextField("Enter an amount...", value: $input, format: .number)
							.keyboardType(.decimalPad)
							.focused($userInputIsFocused)
					} header: {
						Text("Amount to convert")
							.font(.subheadline.bold())
					}
	//				.listRowBackground(Color.darkGrayBackground)
					
					// MARK: - RESULT
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
	//				.listRowBackground(Color.darkGrayBackground)
					
					// MARK: - BUTTONS
					Button("Start Over") {
						showResetAlert = true
					}
					.buttonStyle(ResetButtonModel())
					.disabled(input == 0)
					.opacity(input == 0 ? 0.5 : 1)
					
	//				.listRowBackground(Color.darkGrayBackground)
					
					// iOS 17 check for sf symbol animation
					if #available(iOS 17, *) {
						Toggle(
							isOn: $isDarkMode,
							label: {
								Label(
									title: { Text("") },
									icon: {
										Image(systemName: isDarkMode ? "moon.fill" : "sun.min")
	//										.font(.title3)
	//										.fontWeight(.semibold)
	//										.frame(width: 30, height: 30)
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
				.onChange(of: selectedUnits) {
					let units = unitTypes[selectedUnits]
					inputUnit = units[0]
					outputUnit = units[1]
				}
				// MARK: - ALERT
				.alert(isPresented: $showResetAlert) {
					Alert(
						title: Text("Reset ALL THE THINGS?"),
						message: Text("This will reset all options to their default values."),
						primaryButton: .default(Text("Reset")) {
							reset()
						},
						secondaryButton: .cancel(Text("Cancel"))
					)
				}
			}
		}
    }
	// MARK: - METHODS
	/// Resets user inputted amounts for Input and Selected Units back to defaults
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
	
	/// Presents the rating and review request view after a two-second delay.
	func presentReview() {
		Task {
			// Delay for two seconds to avoid interrupting the person using the app.
			try await Task.sleep(for: .seconds(2))
			
			requestReview()
		}
	}
}

// MARK: - PREVIEWS
struct ConversionView_Previews: PreviewProvider {
    static var previews: some View {
		ConversionView()
			
    }
}
