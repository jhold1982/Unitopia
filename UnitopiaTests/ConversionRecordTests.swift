//
//  ConversionRecordTests.swift
//  UnitopiaTests
//
//  Created by Justin Hold on 2/27/26.
//

import Testing
import Foundation
import SwiftData
@testable import Unitopia

@Suite("ConversionRecord")
struct ConversionRecordTests {

    // MARK: - Helpers

    /// Creates an in-memory SwiftData container for testing.
    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: ConversionRecord.self, FavoriteUnitPair.self, configurations: config)
    }

    private func makeSampleRecord(
        inputValue: Double = 100,
        inputSymbol: String = UnitTemperature.fahrenheit.symbol,
        outputSymbol: String = UnitTemperature.celsius.symbol,
        category: String = "Temperature",
        resultValue: Double = 37.78,
        formattedResult: String = "37.78°C",
        inputLabel: String = "Fahrenheit",
        outputLabel: String = "Celsius",
        isFavorite: Bool = false
    ) -> ConversionRecord {
        ConversionRecord(
            inputValue: inputValue,
            inputUnitSymbol: inputSymbol,
            outputUnitSymbol: outputSymbol,
            categoryName: category,
            resultValue: resultValue,
            formattedResult: formattedResult,
            inputUnitLabel: inputLabel,
            outputUnitLabel: outputLabel,
            isFavorite: isFavorite
        )
    }

    // MARK: - Initializer Defaults

    @Test("Default isFavorite is false")
    func defaultIsFavorite() {
        let record = makeSampleRecord()
        #expect(record.isFavorite == false)
    }

    @Test("Default timestamp is approximately now")
    func defaultTimestampIsNow() {
        let before = Date.now
        let record = makeSampleRecord()
        let after = Date.now
        #expect(record.timestamp >= before)
        #expect(record.timestamp <= after)
    }

    @Test("Stored values match initializer arguments")
    func storedValuesMatchInit() {
        let record = makeSampleRecord(
            inputValue: 212,
            inputSymbol: "°F",
            outputSymbol: "°C",
            category: "Temperature",
            resultValue: 100,
            formattedResult: "100°C",
            inputLabel: "Fahrenheit",
            outputLabel: "Celsius",
            isFavorite: true
        )
        #expect(record.inputValue == 212)
        #expect(record.inputUnitSymbol == "°F")
        #expect(record.outputUnitSymbol == "°C")
        #expect(record.categoryName == "Temperature")
        #expect(record.resultValue == 100)
        #expect(record.formattedResult == "100°C")
        #expect(record.inputUnitLabel == "Fahrenheit")
        #expect(record.outputUnitLabel == "Celsius")
        #expect(record.isFavorite == true)
    }

    // MARK: - SwiftData Persistence

    @Test("Record can be inserted and fetched from in-memory store")
    func insertAndFetch() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let record = makeSampleRecord()
        context.insert(record)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<ConversionRecord>())
        #expect(fetched.count == 1)
        #expect(fetched.first?.inputValue == 100)
        #expect(fetched.first?.categoryName == "Temperature")
    }

    @Test("Multiple records can be inserted and fetched")
    func insertMultipleRecords() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        for i in 1...5 {
            context.insert(makeSampleRecord(inputValue: Double(i * 10)))
        }
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<ConversionRecord>())
        #expect(fetched.count == 5)
    }

    @Test("Record can be deleted from store")
    func deleteRecord() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let record = makeSampleRecord()
        context.insert(record)
        try context.save()

        context.delete(record)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<ConversionRecord>())
        #expect(fetched.isEmpty)
    }

    @Test("isFavorite can be toggled and persisted")
    func toggleFavoritePersists() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let record = makeSampleRecord(isFavorite: false)
        context.insert(record)
        try context.save()

        record.isFavorite = true
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<ConversionRecord>())
        #expect(fetched.first?.isFavorite == true)
    }

    @Test("Fetching only favorites returns correct subset")
    func fetchOnlyFavorites() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        context.insert(makeSampleRecord(isFavorite: true))
        context.insert(makeSampleRecord(isFavorite: false))
        context.insert(makeSampleRecord(isFavorite: true))
        try context.save()

        let descriptor = FetchDescriptor<ConversionRecord>(
            predicate: #Predicate { $0.isFavorite }
        )
        let favorites = try context.fetch(descriptor)
        #expect(favorites.count == 2)
    }

    @Test("Records are sorted by timestamp in descending order")
    func sortByTimestampDescending() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let early = ConversionRecord(
            inputValue: 1, inputUnitSymbol: "°F", outputUnitSymbol: "°C",
            categoryName: "Temperature", resultValue: 0, formattedResult: "0°C",
            inputUnitLabel: "Fahrenheit", outputUnitLabel: "Celsius",
            timestamp: Date.now.addingTimeInterval(-100)
        )
        let late = ConversionRecord(
            inputValue: 2, inputUnitSymbol: "°F", outputUnitSymbol: "°C",
            categoryName: "Temperature", resultValue: 0, formattedResult: "0°C",
            inputUnitLabel: "Fahrenheit", outputUnitLabel: "Celsius",
            timestamp: Date.now
        )
        context.insert(early)
        context.insert(late)
        try context.save()

        let descriptor = FetchDescriptor<ConversionRecord>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        let sorted = try context.fetch(descriptor)
        #expect(sorted.first?.inputValue == 2)
        #expect(sorted.last?.inputValue == 1)
    }
}
