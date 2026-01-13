//
//  ContentView.swift
//  Unitopia
//
//  Created by Justin Hold on 9/17/23.
//

import SwiftUI
import StoreKit
import CoreSpotlight
import CoreHaptics

struct ContentView: View {
	
	// MARK: - Properties
	@State private var input = 0.0
	@State private var selectedUnits = 0
	@State private var showResetAlert: Bool = false
	@State private var inputUnit: Dimension = UnitTemperature.fahrenheit
	@State private var outputUnit: Dimension = UnitTemperature.celsius
	@State private var selection: String?
	@State private var engine: CHHapticEngine?
	@State private var showWelcomeScreen: Bool = false
	
	@Environment(\.requestReview) private var requestReview
	@EnvironmentObject var dataController: ReviewManager
	
	@AppStorage("isDarkMode") private var isDarkMode = false
	@AppStorage("processCompletedCount") var processCompletedCount = 0
	@AppStorage("currentAppVersion") var currentAppVersion = "1.2.3"
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
		// Temperature units
		[
			UnitTemperature.fahrenheit,
			UnitTemperature.celsius,
			UnitTemperature.kelvin
		],
		// Distance units
		[
			UnitLength.inches,
			UnitLength.feet,
			UnitLength.meters,
			UnitLength.centimeters,
			UnitLength.miles,
			UnitLength.kilometers
		],
		// Mass units
		[
			UnitMass.grams,
			UnitMass.kilograms,
			UnitMass.pounds,
			UnitMass.ounces
		],
		// Time units
		[
			UnitDuration.hours,
			UnitDuration.minutes,
			UnitDuration.seconds,
			UnitDuration.milliseconds
		],
		// Speed units
		[
			UnitSpeed.milesPerHour,
			UnitSpeed.kilometersPerHour,
			UnitSpeed.metersPerSecond
		],
		// Volume units
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
					
					Section {
						TextField("Enter an amount...", value: $input, format: .number)
							.keyboardType(.decimalPad)
							.focused($userInputIsFocused)
					} header: {
						Text("Amount to convert")
							.font(.subheadline.bold())
					}
					
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
						complexHaptics()
					}
					.buttonStyle(ResetButtonModel())
					.disabled(input == 0)
					.opacity(input == 0 ? 0.5 : 1)
					.onAppear(perform: {
						prepareHaptics()
					})
					
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
						title: Text("Reset Settings?"),
						message: Text("This will reset all the things.."),
						primaryButton: .default(Text("Reset")) {
							reset()
						},
						secondaryButton: .cancel(Text("Cancel"))
					)
				}
			}
		}
	}
	
    
    // MARK: - Logic
	func reset() {
		input = 0.0
		selectedUnits = 0
        isDarkMode = false
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
	
	func prepareHaptics() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		
		do {
			engine = try CHHapticEngine()
			try engine?.start()
		} catch {
			print("There was a problem creating the engine: \(error.localizedDescription)")
		}
	}
	
	func complexHaptics() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		
		var events = [CHHapticEvent]()
		
		// First wave: Increasing intensity, decreasing sharpness
		for i in stride(from: 0, to: 1, by: 0.1) {
			let intensity = CHHapticEventParameter(
				parameterID: .hapticIntensity,
				value: Float(i)
			)
			
			let sharpness = CHHapticEventParameter(
				parameterID: .hapticSharpness,
				value: Float(1 - i)
			)
			
			let event = CHHapticEvent(
				eventType: .hapticTransient,
				parameters: [intensity, sharpness],
				relativeTime: i
			)
			
			events.append(event)
		}
		
		// Second wave: Decreasing intensity, continuing to decrease sharpness
		for i in stride(from: 0, to: 1, by: 0.1) {
			let intensity = CHHapticEventParameter(
				parameterID: .hapticIntensity,
				value: Float(1 - i)
			)
			
			let sharpness = CHHapticEventParameter(
				parameterID: .hapticSharpness,
				value: Float(1 - i)
			)
			
			let event = CHHapticEvent(
				eventType: .hapticTransient,
				parameters: [intensity, sharpness],
				relativeTime: 1 + i
			)
			
			events.append(event)
		}
		
		do {
			let pattern = try CHHapticPattern(events: events, parameters: [])
			let player = try engine?.makePlayer(with: pattern)
			try player?.start(atTime: 0)
		} catch {
			print("Failed to play pattern: \(error.localizedDescription)")
		}
	}
}

#Preview {
    ContentView()
}
