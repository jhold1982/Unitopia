//
//  FavoritesView.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import SwiftUI
import SwiftData

/// The Favorites tab — a searchable, segmented list of favorited conversions and unit pairs.
struct FavoritesView: View {

    // MARK: - Segment
    enum FavoriteSegment: String, CaseIterable {
        case conversions = "Conversions"
        case unitPairs = "Unit Pairs"
    }

    // MARK: - State
    @State private var selectedSegment: FavoriteSegment = .conversions
    @State private var searchText = ""

    // MARK: - Queries
    @Query(
        filter: #Predicate<ConversionRecord> { $0.isFavorite },
        sort: \ConversionRecord.timestamp,
        order: .reverse
    )
    private var favoriteConversions: [ConversionRecord]

    @Query(sort: \FavoriteUnitPair.createdAt, order: .reverse)
    private var favoriteUnitPairs: [FavoriteUnitPair]

    @Environment(\.modelContext) private var modelContext

    // MARK: - Filtered Data
    private var filteredConversions: [ConversionRecord] {
        guard !searchText.isEmpty else { return favoriteConversions }
        return favoriteConversions.filter { record in
            record.inputUnitLabel.localizedCaseInsensitiveContains(searchText) ||
            record.outputUnitLabel.localizedCaseInsensitiveContains(searchText) ||
            record.categoryName.localizedCaseInsensitiveContains(searchText) ||
            record.formattedResult.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var filteredUnitPairs: [FavoriteUnitPair] {
        guard !searchText.isEmpty else { return favoriteUnitPairs }
        return favoriteUnitPairs.filter { pair in
            pair.inputUnitLabel.localizedCaseInsensitiveContains(searchText) ||
            pair.outputUnitLabel.localizedCaseInsensitiveContains(searchText) ||
            pair.categoryName.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - View Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedSegment) {
                    ForEach(FavoriteSegment.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)

                List {
                    switch selectedSegment {
                    case .conversions:
                        if filteredConversions.isEmpty {
                            emptyState(
                                title: searchText.isEmpty ? "No Favorite Conversions" : "No Results",
                                subtitle: searchText.isEmpty
                                    ? "Swipe right on a conversion in the Home tab to star it."
                                    : "Try a different search term.",
                                icon: "star"
                            )
                        } else {
                            ForEach(filteredConversions) { record in
                                ConversionRecordRow(record: record)
                            }
                            .onDelete(perform: deleteConversions)
                        }

                    case .unitPairs:
                        if filteredUnitPairs.isEmpty {
                            emptyState(
                                title: searchText.isEmpty ? "No Favorite Unit Pairs" : "No Results",
                                subtitle: searchText.isEmpty
                                    ? "Tap the star icon in the converter to save a unit pair."
                                    : "Try a different search term.",
                                icon: "arrow.left.arrow.right"
                            )
                        } else {
                            ForEach(filteredUnitPairs) { pair in
                                FavoriteUnitPairRow(pair: pair)
                            }
                            .onDelete(perform: deleteUnitPairs)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .searchable(text: $searchText, prompt: "Search favorites")
            .toolbar {
                if !filteredConversions.isEmpty || !filteredUnitPairs.isEmpty {
                    EditButton()
                }
            }
        }
    }

    // MARK: - Helpers
    @ViewBuilder
    private func emptyState(
        title: String,
        subtitle: String,
        icon: String
    ) -> some View {
        ContentUnavailableView(
            title,
            systemImage: icon,
            description: Text(subtitle)
        )
        .listRowBackground(Color.clear)
    }

    private func deleteConversions(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredConversions[index])
        }
    }

    private func deleteUnitPairs(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredUnitPairs[index])
        }
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: [ConversionRecord.self, FavoriteUnitPair.self], inMemory: true)
        .environmentObject(ReviewManager())
}
