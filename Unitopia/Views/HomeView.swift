//
//  HomeView.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import SwiftUI
import SwiftData

/// The Home tab — a dashboard showing a quick-access converter link and recent conversion history.
struct HomeView: View {

    @Query(sort: \ConversionRecord.timestamp, order: .reverse)
    private var allRecords: [ConversionRecord]

    /// Show the 20 most recent conversions on the dashboard.
    private var recentRecords: [ConversionRecord] {
        Array(allRecords.prefix(20))
    }

    var body: some View {
        NavigationStack {
            List {
                // Quick access to the converter
                Section {
                    NavigationLink(destination: ConverterView()) {
                        Label("New Conversion", systemImage: "plus.circle.fill")
                            .font(.body.weight(.medium))
                            .foregroundStyle(.blue)
                    }
                }

                // Recent conversion history
                Section {
                    if recentRecords.isEmpty {
                        ContentUnavailableView(
                            "No Conversions Yet",
                            systemImage: "arrow.left.arrow.right",
                            description: Text("Your recent conversions will appear here after you use the converter.")
                        )
                        .listRowBackground(Color.clear)
                    } else {
                        ForEach(recentRecords) { record in
                            ConversionRecordRow(record: record)
                        }
                    }
                } header: {
                    Text("Recent")
                }
            }
            .navigationTitle("Unitopia")
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [ConversionRecord.self, FavoriteUnitPair.self], inMemory: true)
        .environmentObject(ReviewManager())
}
