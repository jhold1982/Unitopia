//
//  ConversionRecord.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import Foundation
import SwiftData

/// A persisted record of a single unit conversion the user performed.
///
/// Unit types are stored as symbol strings (e.g. `"degF"`, `"m"`) because `Dimension`
/// is not `Codable`. Use `ConversionCategory.unit(forSymbol:)` to reconstruct a
/// `Dimension` from its symbol when needed.
@Model
final class ConversionRecord {

    /// The numeric value the user entered.
    var inputValue: Double

    /// The Foundation symbol of the input unit (e.g. `"degF"`).
    var inputUnitSymbol: String

    /// The Foundation symbol of the output unit (e.g. `"degC"`).
    var outputUnitSymbol: String

    /// The display name of the category (e.g. `"Temperature"`).
    var categoryName: String

    /// The raw numeric result of the conversion.
    var resultValue: Double

    /// A human-readable formatted result string (e.g. `"37.78°C"`).
    var formattedResult: String

    /// The human-readable label for the input unit (e.g. `"Fahrenheit"`).
    var inputUnitLabel: String

    /// The human-readable label for the output unit (e.g. `"Celsius"`).
    var outputUnitLabel: String

    /// When this conversion was performed.
    var timestamp: Date

    /// Whether the user has marked this conversion as a favorite.
    var isFavorite: Bool

    init(
        inputValue: Double,
        inputUnitSymbol: String,
        outputUnitSymbol: String,
        categoryName: String,
        resultValue: Double,
        formattedResult: String,
        inputUnitLabel: String,
        outputUnitLabel: String,
        timestamp: Date = .now,
        isFavorite: Bool = false
    ) {
        self.inputValue = inputValue
        self.inputUnitSymbol = inputUnitSymbol
        self.outputUnitSymbol = outputUnitSymbol
        self.categoryName = categoryName
        self.resultValue = resultValue
        self.formattedResult = formattedResult
        self.inputUnitLabel = inputUnitLabel
        self.outputUnitLabel = outputUnitLabel
        self.timestamp = timestamp
        self.isFavorite = isFavorite
    }
}
