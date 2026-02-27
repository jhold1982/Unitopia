//
//  ConverterViewModelTests.swift
//  UnitopiaTests
//
//  Created by Justin Hold on 2/27/26.
//

import Testing
import Foundation
@testable import Unitopia

@Suite("ConverterViewModel")
struct ConverterViewModelTests {

    // MARK: - Initial State

    @Test("Initial state has correct defaults")
    func initialState() {
        let vm = ConverterViewModel()
        #expect(vm.input == 0)
        #expect(vm.selectedCategoryIndex == 0)
        #expect(vm.inputUnit.symbol == UnitTemperature.fahrenheit.symbol)
        #expect(vm.outputUnit.symbol == UnitTemperature.celsius.symbol)
    }

    // MARK: - Conversion Results

    @Test("0°F converts correctly to Celsius")
    func zeroFahrenheitToCelsius() {
        let vm = ConverterViewModel()
        vm.input = 0
        // 0°F = -17.7778°C
        #expect(abs(vm.resultValue - (-17.7778)) < 0.001)
    }

    @Test("32°F converts to 0°C")
    func freezingPointFahrenheitToCelsius() {
        let vm = ConverterViewModel()
        vm.input = 32
        #expect(abs(vm.resultValue - 0.0) < 0.001)
    }

    @Test("212°F converts to 100°C")
    func boilingPointFahrenheitToCelsius() {
        let vm = ConverterViewModel()
        vm.input = 212
        #expect(abs(vm.resultValue - 100.0) < 0.001)
    }

    @Test("result string is non-empty when input is non-zero")
    func resultStringNonEmpty() {
        let vm = ConverterViewModel()
        vm.input = 100
        #expect(!vm.result.isEmpty)
    }

    @Test("result string contains expected unit symbol")
    func resultStringContainsUnit() {
        let vm = ConverterViewModel()
        vm.input = 100
        // Short style formatter should include a degree symbol or "C"
        #expect(vm.result.contains("C") || vm.result.contains("°"))
    }

    // MARK: - Distance Conversion

    @Test("1 mile converts correctly to kilometers")
    func milesToKilometers() {
        let vm = ConverterViewModel()
        vm.configure(
            categoryName: "Distance",
            inputSymbol: UnitLength.miles.symbol,
            outputSymbol: UnitLength.kilometers.symbol
        )
        vm.input = 1
        #expect(abs(vm.resultValue - 1.60934) < 0.001)
    }

    @Test("100 meters converts correctly to centimeters")
    func metersToCentimeters() {
        let vm = ConverterViewModel()
        vm.configure(
            categoryName: "Distance",
            inputSymbol: UnitLength.meters.symbol,
            outputSymbol: UnitLength.centimeters.symbol
        )
        vm.input = 100
        #expect(abs(vm.resultValue - 10000.0) < 0.001)
    }

    // MARK: - Mass Conversion

    @Test("1 kilogram converts correctly to pounds")
    func kilogramsToPounds() {
        let vm = ConverterViewModel()
        vm.configure(
            categoryName: "Mass",
            inputSymbol: UnitMass.kilograms.symbol,
            outputSymbol: UnitMass.pounds.symbol
        )
        vm.input = 1
        #expect(abs(vm.resultValue - 2.20462) < 0.001)
    }

    // MARK: - Category Switching

    @Test("Changing selectedCategoryIndex resets input and output units to first two in category")
    func categoryChangeResetsUnits() {
        let vm = ConverterViewModel()
        // Switch to Distance (index 1)
        vm.selectedCategoryIndex = 1
        let distanceUnits = ConversionCategory.all[1].units
        #expect(vm.inputUnit.symbol == distanceUnits[0].symbol)
        #expect(vm.outputUnit.symbol == distanceUnits[1].symbol)
    }

    @Test("Switching to every category sets valid units")
    func allCategoriesProduceValidUnits() {
        let vm = ConverterViewModel()
        for idx in ConversionCategory.all.indices {
            vm.selectedCategoryIndex = idx
            let category = ConversionCategory.all[idx]
            #expect(vm.inputUnit.symbol == category.units[0].symbol)
            #expect(vm.outputUnit.symbol == category.units[1].symbol)
        }
    }

    // MARK: - configure()

    @Test("configure() correctly sets category and units by symbol")
    func configureBySymbol() {
        let vm = ConverterViewModel()
        vm.configure(
            categoryName: "Mass",
            inputSymbol: UnitMass.pounds.symbol,
            outputSymbol: UnitMass.grams.symbol
        )
        #expect(vm.inputUnit.symbol == UnitMass.pounds.symbol)
        #expect(vm.outputUnit.symbol == UnitMass.grams.symbol)
        #expect(vm.selectedCategoryIndex == ConversionCategory.categoryIndex(forName: "Mass"))
    }

    @Test("configure() with unknown category name leaves index unchanged")
    func configureUnknownCategory() {
        let vm = ConverterViewModel()
        let originalIndex = vm.selectedCategoryIndex
        vm.configure(categoryName: "Nonsense", inputSymbol: "x", outputSymbol: "y")
        #expect(vm.selectedCategoryIndex == originalIndex)
    }

    @Test("configure() with unknown symbols leaves units unchanged")
    func configureUnknownSymbols() {
        let vm = ConverterViewModel()
        let originalInput = vm.inputUnit.symbol
        let originalOutput = vm.outputUnit.symbol
        vm.configure(categoryName: "Temperature", inputSymbol: "??", outputSymbol: "!!")
        #expect(vm.inputUnit.symbol == originalInput)
        #expect(vm.outputUnit.symbol == originalOutput)
    }

    // MARK: - reset()

    @Test("reset() sets input to zero and resets category to 0")
    func resetClearsState() {
        let vm = ConverterViewModel()
        vm.input = 42
        vm.selectedCategoryIndex = 2
        vm.reset()
        #expect(vm.input == 0)
        #expect(vm.selectedCategoryIndex == 0)
    }

    @Test("reset() increments processCompletedCount")
    func resetIncrementsCount() {
        let vm = ConverterViewModel()
        let before = vm.processCompletedCount
        vm.reset()
        #expect(vm.processCompletedCount == before + 1)
    }

    // MARK: - label(for:)

    @Test("label(for:) returns non-empty string containing the unit symbol")
    func labelForUnit() {
        let vm = ConverterViewModel()
        let label = vm.label(for: UnitTemperature.fahrenheit)
        #expect(!label.isEmpty)
        #expect(label.contains(UnitTemperature.fahrenheit.symbol))
    }

    @Test("label(for:) returns different strings for different units")
    func labelsAreDistinct() {
        let vm = ConverterViewModel()
        let fahrenheit = vm.label(for: UnitTemperature.fahrenheit)
        let celsius = vm.label(for: UnitTemperature.celsius)
        #expect(fahrenheit != celsius)
    }
}
