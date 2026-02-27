//
//  FavoriteUnitPairRow.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import SwiftUI
import SwiftData

/// A list row displaying a saved `FavoriteUnitPair`.
///
/// Tapping navigates to the converter pre-configured with this unit pair.
/// Swipe left to delete.
struct FavoriteUnitPairRow: View {

    let pair: FavoriteUnitPair
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationLink(destination: ConverterView(preselectedPair: pair)) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(pair.inputUnitLabel)
                        .font(.body.weight(.medium))
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(pair.outputUnitLabel)
                        .font(.body.weight(.medium))
                }
                Text(pair.categoryName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 2)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                modelContext.delete(pair)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
