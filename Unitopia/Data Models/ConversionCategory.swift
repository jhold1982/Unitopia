//
//  ConversionCategory.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import Foundation

/// A conversion category pairing a display name with its available units.
///
/// Using a single struct eliminates the risk of the name and unit arrays going
/// out of sync when categories are added or reordered.
///
/// Example:
/// ```swift
/// let category = ConversionCategory.all[selectedIndex]
/// print(category.name)          // "Temperature"
/// print(category.units.first!)  // UnitTemperature.fahrenheit
/// ```
struct ConversionCategory {

    /// The display name shown in the category picker.
    let name: String

    /// The ordered list of units available for this category.
    let units: [Dimension]

    // MARK: - Lookup Helpers

    /// Returns the `Dimension` instance whose `symbol` matches the given string.
    ///
    /// Used to reconstruct a `Dimension` from a persisted symbol string
    /// (e.g. `"degF"` → `UnitTemperature.fahrenheit`).
    static func unit(forSymbol symbol: String) -> Dimension? {
        for category in all {
            if let match = category.units.first(where: { $0.symbol == symbol }) {
                return match
            }
        }
        return nil
    }

    /// Returns the index into `ConversionCategory.all` for the given category name, or `nil`.
    static func categoryIndex(forName name: String) -> Int? {
        all.firstIndex(where: { $0.name == name })
    }

    // MARK: - All Categories

    /// The canonical ordered list of all supported conversion categories.
    static let all: [ConversionCategory] = [
        ConversionCategory(
            name: "Temperature",
            units: [
                UnitTemperature.fahrenheit,
                UnitTemperature.celsius,
                UnitTemperature.kelvin
            ]
        ),
        ConversionCategory(
            name: "Distance",
            units: [
                UnitLength.inches,
                UnitLength.feet,
                UnitLength.meters,
                UnitLength.centimeters,
                UnitLength.miles,
                UnitLength.kilometers
            ]
        ),
        ConversionCategory(
            name: "Mass",
            units: [
                UnitMass.grams,
                UnitMass.kilograms,
                UnitMass.pounds,
                UnitMass.ounces
            ]
        ),
        ConversionCategory(
            name: "Time",
            units: [
                UnitDuration.hours,
                UnitDuration.minutes,
                UnitDuration.seconds,
                UnitDuration.milliseconds
            ]
        ),
        ConversionCategory(
            name: "Speed",
            units: [
                UnitSpeed.milesPerHour,
                UnitSpeed.kilometersPerHour,
                UnitSpeed.metersPerSecond
            ]
        ),
        ConversionCategory(
            name: "Volume",
            units: [
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
        )
    ]
}
