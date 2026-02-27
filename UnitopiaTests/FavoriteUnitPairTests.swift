//
//  FavoriteUnitPairTests.swift
//  UnitopiaTests
//
//  Created by Justin Hold on 2/27/26.
//

import Testing
import Foundation
import SwiftData
@testable import Unitopia

@Suite("FavoriteUnitPair")
struct FavoriteUnitPairTests {

    // MARK: - Helpers

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: ConversionRecord.self, FavoriteUnitPair.self, configurations: config)
    }

    private func makePair(
        category: String = "Temperature",
        inputSymbol: String = UnitTemperature.fahrenheit.symbol,
        outputSymbol: String = UnitTemperature.celsius.symbol,
        inputLabel: String = "Fahrenheit",
        outputLabel: String = "Celsius"
    ) -> FavoriteUnitPair {
        FavoriteUnitPair(
            categoryName: category,
            inputUnitSymbol: inputSymbol,
            outputUnitSymbol: outputSymbol,
            inputUnitLabel: inputLabel,
            outputUnitLabel: outputLabel
        )
    }

    // MARK: - Initializer

    @Test("Stored values match initializer arguments")
    func storedValuesMatchInit() {
        let pair = makePair()
        #expect(pair.categoryName == "Temperature")
        #expect(pair.inputUnitSymbol == UnitTemperature.fahrenheit.symbol)
        #expect(pair.outputUnitSymbol == UnitTemperature.celsius.symbol)
        #expect(pair.inputUnitLabel == "Fahrenheit")
        #expect(pair.outputUnitLabel == "Celsius")
    }

    @Test("Default createdAt is approximately now")
    func defaultCreatedAtIsNow() {
        let before = Date.now
        let pair = makePair()
        let after = Date.now
        #expect(pair.createdAt >= before)
        #expect(pair.createdAt <= after)
    }

    // MARK: - SwiftData Persistence

    @Test("Pair can be inserted and fetched from in-memory store")
    func insertAndFetch() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        context.insert(makePair())
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<FavoriteUnitPair>())
        #expect(fetched.count == 1)
        #expect(fetched.first?.categoryName == "Temperature")
    }

    @Test("Pair can be deleted from store")
    func deletePair() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let pair = makePair()
        context.insert(pair)
        try context.save()

        context.delete(pair)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<FavoriteUnitPair>())
        #expect(fetched.isEmpty)
    }

    @Test("Multiple pairs with different symbols can coexist")
    func multiplePairsCoexist() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        context.insert(makePair(
            inputSymbol: UnitTemperature.fahrenheit.symbol,
            outputSymbol: UnitTemperature.celsius.symbol
        ))
        context.insert(makePair(
            category: "Distance",
            inputSymbol: UnitLength.miles.symbol,
            outputSymbol: UnitLength.kilometers.symbol,
            inputLabel: "Miles",
            outputLabel: "Kilometers"
        ))
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<FavoriteUnitPair>())
        #expect(fetched.count == 2)
    }

    @Test("Pairs are sorted by createdAt in descending order")
    func sortByCreatedAtDescending() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let old = FavoriteUnitPair(
            categoryName: "Temperature",
            inputUnitSymbol: UnitTemperature.fahrenheit.symbol,
            outputUnitSymbol: UnitTemperature.celsius.symbol,
            inputUnitLabel: "Fahrenheit",
            outputUnitLabel: "Celsius",
            createdAt: Date.now.addingTimeInterval(-200)
        )
        let new = FavoriteUnitPair(
            categoryName: "Mass",
            inputUnitSymbol: UnitMass.pounds.symbol,
            outputUnitSymbol: UnitMass.kilograms.symbol,
            inputUnitLabel: "Pounds",
            outputUnitLabel: "Kilograms",
            createdAt: Date.now
        )
        context.insert(old)
        context.insert(new)
        try context.save()

        let descriptor = FetchDescriptor<FavoriteUnitPair>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let sorted = try context.fetch(descriptor)
        #expect(sorted.first?.categoryName == "Mass")
        #expect(sorted.last?.categoryName == "Temperature")
    }

    @Test("In-memory filter by symbol matches correct pairs")
    func inMemoryFilterBySymbol() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let targetInput = UnitLength.miles.symbol
        let targetOutput = UnitLength.kilometers.symbol

        context.insert(makePair())  // Temperature pair — should NOT match
        context.insert(makePair(
            category: "Distance",
            inputSymbol: targetInput,
            outputSymbol: targetOutput,
            inputLabel: "Miles",
            outputLabel: "Kilometers"
        ))
        try context.save()

        let all = try context.fetch(FetchDescriptor<FavoriteUnitPair>())
        let filtered = all.filter {
            $0.inputUnitSymbol == targetInput && $0.outputUnitSymbol == targetOutput
        }
        #expect(filtered.count == 1)
        #expect(filtered.first?.categoryName == "Distance")
    }
}
