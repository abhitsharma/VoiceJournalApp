//
//  JournalDetailView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI
import SwiftData

struct JournalDetailView: View {
    @Bindable var entry: JournalEntry
    var viewModel: JournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    
    var body: some View {
        ZStack {
                LinearGradient(
                    colors: [Color(red: 0.98, green: 0.97, blue: 0.95),
                             Color(red: 0.93, green: 0.88, blue: 0.85)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(entry.title)
                            .font(.largeTitle.bold())
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                        
                        Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        Text(entry.content)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(6)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
                    )
                    .padding()
                }
            }
            .navigationTitle("Journal Entry")
            .tint(Color(red: 0.8, green: 0.4, blue: 0.25))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EditJournalView(entry: entry, viewModel: viewModel)
                    } label: {
                        Text("Edit")
                            .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.25))
                    }
                    
                    Button(role: .destructive) {
                        viewModel.deleteEntry(entry)
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.25))
                    }
                }
            }
    }
}



#Preview {
    JournalDetailView(entry: JournalEntry(title: "", content: ""), viewModel: JournalViewModel())
}
