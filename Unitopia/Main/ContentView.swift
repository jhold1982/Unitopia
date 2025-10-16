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

/// A view that provides unit conversion functionality across multiple measurement types.
///
/// `ContentView` offers conversion between various units including:
/// - Temperature (Fahrenheit, Celsius, Kelvin)
/// - Distance (Inches, Feet, Meters, Centimeters, Miles, Kilometers)
/// - Mass (Grams, Kilograms, Pounds, Ounces)
/// - Time (Hours, Minutes, Seconds, Milliseconds)
/// - Speed (Miles per hour, Kilometers per hour, Meters per second)
/// - Volume (Liters, Gallons, Acre Feet, Bushels, Pints, Quarts, Fluid Ounces, Centiliters, Milliliters, Cups)
///
/// The view provides a simple interface for selecting conversion types, input and output units,
/// and entering values. It also includes dark mode support, haptic feedback, and integrated
/// App Store review prompting.
struct ContentView: View {
	
	// MARK: - Properties
	
	/// The current input value to be converted.
	@State private var input = 0.0
	
	/// The index of the currently selected conversion type (temperature, distance, etc.).
	@State private var selectedUnits = 0
	
	/// Controls the visibility of the reset confirmation alert.
	@State private var showResetAlert: Bool = false
	
	/// The currently selected input unit dimension.
	@State private var inputUnit: Dimension = UnitTemperature.fahrenheit
	
	/// The currently selected output unit dimension.
	@State private var outputUnit: Dimension = UnitTemperature.celsius
	
	/// Tracks the current selection in navigation interfaces.
	@State private var selection: String?
	
	/// The haptic engine used for providing tactile feedback.
	@State private var engine: CHHapticEngine?
	
	@State private var showWelcomeScreen: Bool = false
	
	/// Environment value for requesting App Store reviews.
	@Environment(\.requestReview) private var requestReview
	
	/// The app's review management controller.
	@EnvironmentObject var dataController: ReviewManager
	
	/// User preference for dark mode, persisted across app launches.
	@AppStorage("isDarkMode") private var isDarkMode = false
	
	/// Counter tracking how many times the user has completed a process, persisted across app launches.
	@AppStorage("processCompletedCount") var processCompletedCount = 0
	
	/// The current version of the app, used for review prompting logic.
	@AppStorage("currentAppVersion") var currentAppVersion = "1.2.2"
	
	/// The last app version where the user was prompted for a review, persisted across app launches.
	@AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview = "1.2.2"
	
	/// Focus state for the input text field.
	@FocusState private var userInputIsFocused: Bool
	
	/// Formatter for displaying measurement values and unit names.
	let formatter: MeasurementFormatter
	
	/// Available conversion categories.
	let conversionTypes = [
		"Temperature",
		"Distance",
		"Mass",
		"Time",
		"Speed",
		"Volume"
	]
	
	/// Available unit options for each conversion category.
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
	
	/// The formatted result of the current conversion.
	///
	/// This computed property converts the input value from the selected input unit
	/// to the selected output unit and formats the result for display.
	var result: String {
		let inputMeasurement = Measurement(value: input, unit: inputUnit)
		let outputMeasurement = inputMeasurement.converted(to: outputUnit)
		return formatter.string(from: outputMeasurement)
	}
	
	/// Initializes a new ContentView with a configured MeasurementFormatter.
	init() {
		formatter = MeasurementFormatter()
		formatter.unitOptions = .providedUnit
		formatter.unitStyle = .short
	}
	
	// MARK: - View Body
	/* Body implementation... */
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
						title: Text("Praise Kier!"),
						message: Text("This will reset all Tempers to their initial state."),
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
	/// Resets the application state to its initial values.
	///
	/// This function:
	/// - Sets input value to zero
	/// - Clears the selected units
	/// - Increments the process completion counter
	/// - Checks if the app should prompt for a review
	func reset() {
		input = 0.0
		selectedUnits = 0
		processCompletedCount += 1
		experiencedReview()
	}
	
	/// Determines if the app should request a review from the user.
	///
	/// This function checks if the user has completed enough processes since the last review
	/// prompt and if they're using a different app version than when last prompted.
	/// If both conditions are met, a review prompt is presented.
	func experiencedReview() {
		if processCompletedCount >= 3, currentAppVersion != lastVersionPromptedForReview {
			presentReview()
			
			lastVersionPromptedForReview = currentAppVersion
		}
	}
	
	/// Presents the App Store review prompt to the user.
	///
	/// This function adds a slight delay before requesting the review to ensure
	/// the app is in a stable state when the prompt appears.
	func presentReview() {
		Task {
			try await Task.sleep(for: .seconds(2))
			requestReview()
		}
	}
	
	/// Initializes and prepares the haptic feedback engine.
	///
	/// This function:
	/// - Checks if the device supports haptic feedback
	/// - Creates and starts the haptic engine if supported
	/// - Handles and logs any errors that occur during initialization
	///
	/// - Note: This should be called early in the app lifecycle to ensure haptics are ready when needed.
	func prepareHaptics() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		
		do {
			engine = try CHHapticEngine()
			try engine?.start()
		} catch {
			print("There was a problem creating the engine: \(error.localizedDescription)")
		}
	}
	
	/// Creates and plays a complex haptic feedback pattern that gradually increases then decreases in intensity.
	///
	/// This function generates a two-part haptic pattern:
	/// 1. First part: Intensity increases from 0 to 1 while sharpness decreases from 1 to 0
	/// 2. Second part: Intensity decreases from 1 to 0 while sharpness continues to decrease
	///
	/// The complete pattern creates a wave-like sensation that lasts approximately 2 seconds.
	///
	/// - Note: This function requires haptic support and will silently return if the device doesn't support haptics.
	/// - Important: The haptic engine must be prepared using `prepareHaptics()` before calling this function.
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
