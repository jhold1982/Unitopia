//
//  ConverterViewModel.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import SwiftUI
import StoreKit
import Observation

/// The view model for the main converter screen.
///
/// Owns all converter state, the formatted result, and the reset/review logic.
/// `ConverterView` holds one instance via `@State` and reads from it directly —
/// no `ObservableObject` overhead needed thanks to `@Observable`.
@Observable
class ConverterViewModel {

    // MARK: - Converter State

    /// The numeric value the user has entered.
    var input: Double = 0

    /// The index into `ConversionCategory.all` that is currently selected.
    var selectedCategoryIndex: Int = 0 {
        didSet {
            // Keep units in sync whenever the category changes.
            let units = ConversionCategory.all[selectedCategoryIndex].units
            inputUnit = units[0]
            outputUnit = units[1]
        }
    }

    /// The unit to convert from.
    var inputUnit: Dimension = UnitTemperature.fahrenheit

    /// The unit to convert to.
    var outputUnit: Dimension = UnitTemperature.celsius

    // MARK: - Review Tracking

    @ObservationIgnored
    @AppStorage("processCompletedCount") var processCompletedCount: Int = 0

    @ObservationIgnored
    @AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview: String = ""

    // MARK: - Formatter

    @ObservationIgnored
    private let formatter: MeasurementFormatter = {
        let f = MeasurementFormatter()
        f.unitOptions = .providedUnit
        f.unitStyle = .short
        return f
    }()

    // MARK: - Computed Properties

    /// The formatted conversion result string.
    var result: String {
        let inputMeasurement = Measurement(value: input, unit: inputUnit)
        let outputMeasurement = inputMeasurement.converted(to: outputUnit)
        return formatter.string(from: outputMeasurement)
    }

    /// The raw numeric result of the conversion.
    var resultValue: Double {
        let inputMeasurement = Measurement(value: input, unit: inputUnit)
        return inputMeasurement.converted(to: outputUnit).value
    }

    /// A formatted string for a given unit, used to populate picker rows.
    func label(for unit: Dimension) -> String {
        formatter.string(from: unit).capitalized
    }

    // MARK: - Actions

    /// Resets all converter state to defaults and increments the completed-action counter.
    func reset() {
        input = 0
        selectedCategoryIndex = 0
        processCompletedCount += 1
    }

    /// Pre-configures the converter from a saved category name and unit symbols.
    ///
    /// Used when navigating to the converter from a `FavoriteUnitPair` or `ConversionRecord`.
    func configure(categoryName: String, inputSymbol: String, outputSymbol: String) {
        if let index = ConversionCategory.categoryIndex(forName: categoryName) {
            selectedCategoryIndex = index
        }
        if let unit = ConversionCategory.unit(forSymbol: inputSymbol) {
            inputUnit = unit
        }
        if let unit = ConversionCategory.unit(forSymbol: outputSymbol) {
            outputUnit = unit
        }
    }

    /// Triggers a review prompt after the user has reset at least 3 times on a new app version.
    ///
    /// Pass the SwiftUI `requestReview` environment action so the view model does not need to
    /// hold a reference to the SwiftUI environment itself.
    func requestReviewIfAppropriate(using requestReview: RequestReviewAction) {
        let currentVersion = Bundle.appVersion
        guard processCompletedCount >= 3, currentVersion != lastVersionPromptedForReview else { return }

        lastVersionPromptedForReview = currentVersion
        // Delay slightly so the prompt appears after the reset animation settles.
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            requestReview()
        }
    }
}
