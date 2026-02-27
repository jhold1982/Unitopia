//
//  ConversionCategoryTests.swift
//  UnitopiaTests
//
//  Created by Justin Hold on 2/27/26.
//

import Testing
import Foundation
@testable import Unitopia

@Suite("ConversionCategory")
struct ConversionCategoryTests {

    // MARK: - Static Data Integrity

    @Test("all contains exactly 6 categories")
    func categoryCount() {
        #expect(ConversionCategory.all.count == 6)
    }

    @Test("all category names are unique")
    func categoryNamesUnique() {
        let names = ConversionCategory.all.map(\.name)
        #expect(Set(names).count == names.count)
    }

    @Test("every category has at least 2 units")
    func eachCategoryHasMinimumUnits() {
        for category in ConversionCategory.all {
            #expect(category.units.count >= 2, "Category '\(category.name)' needs at least 2 units")
        }
    }

    @Test("expected category names are present")
    func expectedNamesPresent() {
        let names = Set(ConversionCategory.all.map(\.name))
        #expect(names.contains("Temperature"))
        #expect(names.contains("Distance"))
        #expect(names.contains("Mass"))
        #expect(names.contains("Time"))
        #expect(names.contains("Speed"))
        #expect(names.contains("Volume"))
    }

    @Test("Temperature category contains Fahrenheit, Celsius, Kelvin")
    func temperatureUnits() {
        let temp = ConversionCategory.all.first { $0.name == "Temperature" }
        #expect(temp != nil)
        let symbols = temp!.units.map(\.symbol)
        #expect(symbols.contains(UnitTemperature.fahrenheit.symbol))
        #expect(symbols.contains(UnitTemperature.celsius.symbol))
        #expect(symbols.contains(UnitTemperature.kelvin.symbol))
    }

    @Test("Distance category contains miles and kilometers")
    func distanceUnits() {
        let dist = ConversionCategory.all.first { $0.name == "Distance" }
        #expect(dist != nil)
        let symbols = dist!.units.map(\.symbol)
        #expect(symbols.contains(UnitLength.miles.symbol))
        #expect(symbols.contains(UnitLength.kilometers.symbol))
    }

    @Test("no category has duplicate unit symbols")
    func noDuplicateUnitsPerCategory() {
        for category in ConversionCategory.all {
            let symbols = category.units.map(\.symbol)
            #expect(Set(symbols).count == symbols.count,
                    "Category '\(category.name)' has duplicate unit symbols")
        }
    }

    // MARK: - unit(forSymbol:)

    @Test("unit(forSymbol:) returns correct unit for known symbol")
    func unitForKnownSymbol() {
        let unit = ConversionCategory.unit(forSymbol: UnitTemperature.celsius.symbol)
        #expect(unit != nil)
        #expect(unit?.symbol == UnitTemperature.celsius.symbol)
    }

    @Test("unit(forSymbol:) returns nil for unknown symbol")
    func unitForUnknownSymbol() {
        let unit = ConversionCategory.unit(forSymbol: "!!unknown!!")
        #expect(unit == nil)
    }

    @Test("unit(forSymbol:) can resolve every unit across all categories")
    func allUnitsResolvable() {
        for category in ConversionCategory.all {
            for unit in category.units {
                let resolved = ConversionCategory.unit(forSymbol: unit.symbol)
                #expect(resolved != nil, "Could not resolve symbol '\(unit.symbol)' in '\(category.name)'")
                #expect(resolved?.symbol == unit.symbol)
            }
        }
    }

    // MARK: - categoryIndex(forName:)

    @Test("categoryIndex(forName:) returns correct index for each category")
    func categoryIndexForKnownNames() {
        for (idx, category) in ConversionCategory.all.enumerated() {
            let found = ConversionCategory.categoryIndex(forName: category.name)
            #expect(found == idx, "Expected index \(idx) for '\(category.name)', got \(String(describing: found))")
        }
    }

    @Test("categoryIndex(forName:) returns nil for unknown name")
    func categoryIndexForUnknownName() {
        let idx = ConversionCategory.categoryIndex(forName: "Electricity")
        #expect(idx == nil)
    }

    @Test("categoryIndex(forName:) is case-sensitive")
    func categoryIndexCaseSensitive() {
        // Names in all are title-cased; lowercase should not match
        let idx = ConversionCategory.categoryIndex(forName: "temperature")
        #expect(idx == nil)
    }
}
