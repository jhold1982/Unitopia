//
//  ConversionRecordRow.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import SwiftUI
import SwiftData

/// A list row displaying a single `ConversionRecord`.
///
/// - Swipe left → Delete
/// - Swipe right → Toggle favorite (star)
/// - Tap → Opens the converter pre-populated with this conversion
struct ConversionRecordRow: View {

    let record: ConversionRecord
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationLink(destination: ConverterView(fromRecord: record)) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(formattedInput) \(record.inputUnitLabel)")
                        .font(.body.weight(.medium))
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(record.formattedResult)
                        .font(.body.weight(.medium))
                }
                HStack {
                    Text(record.categoryName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(record.timestamp, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.vertical, 2)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                record.isFavorite.toggle()
            } label: {
                Label(
                    record.isFavorite ? "Unfavorite" : "Favorite",
                    systemImage: record.isFavorite ? "star.slash.fill" : "star.fill"
                )
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                modelContext.delete(record)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private var formattedInput: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: record.inputValue)) ?? "\(record.inputValue)"
    }
}
