//
//  ConverterView.swift
//  Unitopia
//
//  Created by Justin Hold on 9/17/23.
//

import SwiftUI
import StoreKit
import SwiftData

struct ConverterView: View {

    // MARK: - Properties

    @State private var viewModel: ConverterViewModel
    private let haptics = HapticsManager()
    @State private var showResetAlert = false
    @State private var isCurrentPairFavorited = false

    @Environment(\.requestReview) private var requestReview
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var dataController: ReviewManager

    @FocusState private var userInputIsFocused: Bool

    // MARK: - Init

    /// Creates a converter with default (Temperature: Fahrenheit → Celsius) state.
    init() {
        _viewModel = State(wrappedValue: ConverterViewModel())
    }

    /// Creates a converter pre-populated from a saved `FavoriteUnitPair`.
    init(preselectedPair: FavoriteUnitPair) {
        let vm = ConverterViewModel()
        vm.configure(
            categoryName: preselectedPair.categoryName,
            inputSymbol: preselectedPair.inputUnitSymbol,
            outputSymbol: preselectedPair.outputUnitSymbol
        )
        _viewModel = State(wrappedValue: vm)
    }

    /// Creates a converter pre-populated from a saved `ConversionRecord`.
    init(fromRecord record: ConversionRecord) {
        let vm = ConverterViewModel()
        vm.configure(
            categoryName: record.categoryName,
            inputSymbol: record.inputUnitSymbol,
            outputSymbol: record.outputUnitSymbol
        )
        vm.input = record.inputValue
        _viewModel = State(wrappedValue: vm)
    }

    // MARK: - View Body

    var body: some View {
        Form {
            // Category + unit pickers
            Section {
                Picker("Conversion", selection: $viewModel.selectedCategoryIndex) {
                    ForEach(ConversionCategory.all.indices, id: \.self) {
                        Text(ConversionCategory.all[$0].name)
                    }
                }
                .pickerStyle(.menu)

                Picker("Convert from:", selection: $viewModel.inputUnit) {
                    ForEach(ConversionCategory.all[viewModel.selectedCategoryIndex].units, id: \.self) {
                        Text(viewModel.label(for: $0))
                    }
                }
                .pickerStyle(.menu)

                Picker("Convert to:", selection: $viewModel.outputUnit) {
                    ForEach(ConversionCategory.all[viewModel.selectedCategoryIndex].units, id: \.self) {
                        Text(viewModel.label(for: $0))
                    }
                }
                .pickerStyle(.menu)

            } header: {
                Text("")
            }

            // Input
            Section {
                TextField("Enter an amount...", value: $viewModel.input, format: .number)
                    .keyboardType(.decimalPad)
                    .focused($userInputIsFocused)
            } header: {
                Text("Amount to convert")
                    .font(.subheadline.bold())
            }

            // Result
            Section {
                if userInputIsFocused || viewModel.input == 0 {
                    Text("--")
                } else {
                    Text(viewModel.result)
                }
            } header: {
                Text("Result")
                    .font(.subheadline.bold())
            }

            // Reset button
            Button("Start Over") {
                showResetAlert = true
                haptics.playResetPattern()
            }
            .buttonStyle(ResetButtonModel())
            .disabled(viewModel.input == 0)
            .opacity(viewModel.input == 0 ? 0.5 : 1)
        }
        .navigationTitle("Converter")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Keyboard Done button
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    userInputIsFocused = false
                }
            }
            // Favorite unit pair toggle
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    toggleFavoritePair()
                } label: {
                    Image(systemName: isCurrentPairFavorited ? "star.fill" : "star")
                }
                .tint(.yellow)
                .accessibilityLabel(isCurrentPairFavorited ? "Remove from favorites" : "Save as favorite")
            }
        }
        .onAppear {
            haptics.prepare()
            refreshPairFavoriteState()
        }
        .onChange(of: viewModel.inputUnit) { refreshPairFavoriteState() }
        .onChange(of: viewModel.outputUnit) { refreshPairFavoriteState() }
        .onChange(of: userInputIsFocused) { wasFocused, isFocused in
            // Record the conversion when the user dismisses the keyboard
            if wasFocused && !isFocused && viewModel.input != 0 {
                recordConversion()
            }
        }
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset Settings?"),
                message: Text("This will reset your current conversion."),
                primaryButton: .default(Text("Reset")) {
                    viewModel.reset()
                    viewModel.requestReviewIfAppropriate(using: requestReview)
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }

    // MARK: - Conversion Recording

    /// Saves the current conversion to history. Skips duplicates within 5 seconds
    /// and prunes the oldest non-favorited records beyond the 100-record limit.
    private func recordConversion() {
        let inputSymbol = viewModel.inputUnit.symbol
        let outputSymbol = viewModel.outputUnit.symbol
        let categoryName = ConversionCategory.all[viewModel.selectedCategoryIndex].name

        // Skip if an identical conversion was recorded in the last 5 seconds
        let recentCutoff = Date.now.addingTimeInterval(-5)
        let currentInput = viewModel.input
        let allRecent = FetchDescriptor<ConversionRecord>(
            predicate: #Predicate { $0.timestamp > recentCutoff }
        )
        let recentRecords = (try? modelContext.fetch(allRecent)) ?? []
        let isDuplicate = recentRecords.contains {
            $0.inputUnitSymbol == inputSymbol &&
            $0.outputUnitSymbol == outputSymbol &&
            $0.inputValue == currentInput
        }
        if isDuplicate { return }

        let record = ConversionRecord(
            inputValue: viewModel.input,
            inputUnitSymbol: inputSymbol,
            outputUnitSymbol: outputSymbol,
            categoryName: categoryName,
            resultValue: viewModel.resultValue,
            formattedResult: viewModel.result,
            inputUnitLabel: viewModel.label(for: viewModel.inputUnit),
            outputUnitLabel: viewModel.label(for: viewModel.outputUnit)
        )
        modelContext.insert(record)

        // Prune oldest non-favorited records beyond 100
        pruneHistoryIfNeeded()
    }

    /// Deletes the oldest non-favorited records if total count exceeds 100.
    private func pruneHistoryIfNeeded() {
        var all = FetchDescriptor<ConversionRecord>(
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        all.fetchLimit = 200
        guard let records = try? modelContext.fetch(all), records.count > 100 else { return }
        let excess = records.filter { !$0.isFavorite }.prefix(records.count - 100)
        excess.forEach { modelContext.delete($0) }
    }

    // MARK: - Favorite Unit Pair

    /// Checks whether the current unit pair is already saved as a favorite.
    private func refreshPairFavoriteState() {
        let inputSymbol = viewModel.inputUnit.symbol
        let outputSymbol = viewModel.outputUnit.symbol
        // Fetch all pairs and filter in-memory — avoids #Predicate translation issues with
        // string-captured locals that can silently fail on some SwiftData versions.
        let descriptor = FetchDescriptor<FavoriteUnitPair>()
        let all = (try? modelContext.fetch(descriptor)) ?? []
        isCurrentPairFavorited = all.contains {
            $0.inputUnitSymbol == inputSymbol && $0.outputUnitSymbol == outputSymbol
        }
    }

    /// Saves or removes the current unit pair from favorites.
    private func toggleFavoritePair() {
        let inputSymbol = viewModel.inputUnit.symbol
        let outputSymbol = viewModel.outputUnit.symbol
        // Fetch all pairs and filter in-memory for reliable matching
        let descriptor = FetchDescriptor<FavoriteUnitPair>()
        let all = (try? modelContext.fetch(descriptor)) ?? []
        let existing = all.filter {
            $0.inputUnitSymbol == inputSymbol && $0.outputUnitSymbol == outputSymbol
        }
        if !existing.isEmpty {
            existing.forEach { modelContext.delete($0) }
            isCurrentPairFavorited = false
        } else {
            let categoryName = ConversionCategory.all[viewModel.selectedCategoryIndex].name
            let pair = FavoriteUnitPair(
                categoryName: categoryName,
                inputUnitSymbol: inputSymbol,
                outputUnitSymbol: outputSymbol,
                inputUnitLabel: viewModel.label(for: viewModel.inputUnit),
                outputUnitLabel: viewModel.label(for: viewModel.outputUnit)
            )
            modelContext.insert(pair)
            isCurrentPairFavorited = true
        }
        // Persist immediately so FavoritesView's @Query picks up the change
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack {
        ConverterView()
            .modelContainer(for: [ConversionRecord.self, FavoriteUnitPair.self], inMemory: true)
            .environmentObject(ReviewManager())
    }
}
