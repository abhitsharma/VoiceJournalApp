//
//  JournalTimelineView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI
import SwiftData

struct JournalTimelineView: View {
    @Environment(\.modelContext) private var context
    @State private var viewModel = JournalViewModel()
    @State private var selectedEntry: JournalEntry? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.98, green: 0.97, blue: 0.95),
                             Color(red: 0.93, green: 0.88, blue: 0.85)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if viewModel.entries.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.entries, id: \.id) { entry in
                                Button {
                                    selectedEntry = entry
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(entry.title)
                                            .font(.headline)
                                            .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.25))
                                            .lineLimit(1)

                                        Text(entry.content)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)

                                        Text(entry.createdAt.formatted(date: .numeric, time: .shortened))
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white.opacity(0.85))
                                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    )
                                }
                                .buttonStyle(.plain) // removes default NavigationLink styling
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Journal")
            .onAppear {
                viewModel.setContext(context)
            }
            .navigationDestination(item: $selectedEntry) { entry in
                JournalDetailView(entry: entry, viewModel: viewModel)
            }
        }
    }
}



#Preview {
    JournalTimelineView()
}
