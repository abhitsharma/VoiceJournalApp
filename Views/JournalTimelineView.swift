//
//  JournalTimelineView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI
import SwiftData

struct JournalTimelineView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    
    var body: some View {
        NavigationStack {
            if entries.isEmpty {
                EmptyStateView()
            } else {
                List {
                    ForEach(entries) { entry in
                        NavigationLink(value: entry) {
                            VStack(alignment: .leading) {
                                Text(entry.title)
                                    .font(.headline)
                                Text(entry.content)
                                    .lineLimit(2)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(entry.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let entry = entries[index]
                            modelContext.delete(entry)
                        }
                        try? modelContext.save()
                    }
                }
                .navigationDestination(for: JournalEntry.self) { entry in
                    JournalDetailView(entry: entry)
                }
                .navigationTitle("My Journal")
            }
        }
    }
}



#Preview {
    JournalTimelineView()
}
