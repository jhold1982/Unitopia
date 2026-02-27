//
//  FavoriteUnitPair.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import Foundation
import SwiftData

/// A persisted favorite unit pair representing a reusable conversion shortcut.
///
/// Unlike `ConversionRecord`, this stores a unit combination without a specific input value,
/// letting users quickly navigate to the converter pre-configured with their preferred units.
@Model
final class FavoriteUnitPair {

    /// The display name of the category (e.g. `"Temperature"`).
    var categoryName: String

    /// The Foundation symbol of the input unit (e.g. `"degF"`).
    var inputUnitSymbol: String

    /// The Foundation symbol of the output unit (e.g. `"degC"`).
    var outputUnitSymbol: String

    /// The human-readable label for the input unit (e.g. `"Fahrenheit"`).
    var inputUnitLabel: String

    /// The human-readable label for the output unit (e.g. `"Celsius"`).
    var outputUnitLabel: String

    /// When this pair was saved.
    var createdAt: Date

    init(
        categoryName: String,
        inputUnitSymbol: String,
        outputUnitSymbol: String,
        inputUnitLabel: String,
        outputUnitLabel: String,
        createdAt: Date = .now
    ) {
        self.categoryName = categoryName
        self.inputUnitSymbol = inputUnitSymbol
        self.outputUnitSymbol = outputUnitSymbol
        self.inputUnitLabel = inputUnitLabel
        self.outputUnitLabel = outputUnitLabel
        self.createdAt = createdAt
    }
}
