//
//  EditJournalView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI

struct EditJournalView: View {
    @Bindable var entry: JournalEntry
    @Environment(\.dismiss) var dismiss
    var viewModel: JournalViewModel
    
    @State private var draftTitle: String = ""
    @State private var draftContent: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.97, blue: 0.95),
                         Color(red: 0.93, green: 0.88, blue: 0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Editable Title
                TextField("Title", text: $draftTitle)
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Editable Content
                TextEditor(text: $draftContent)
                    .padding()
                    .frame(height: 250)
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                Spacer()
                
                // Save / Cancel Buttons
                HStack(spacing: 20) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                    Button("Save") {
                        entry.title = draftTitle
                        entry.content = draftContent
                        entry.updatedAt = Date()
                        try? viewModel.context?.save()
                        viewModel.loadEntries()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.8, green: 0.4, blue: 0.25)) // warm accent
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Edit Entry")
        .tint(Color(red: 0.8, green: 0.4, blue: 0.25))
        .onAppear {
            draftTitle = entry.title
            draftContent = entry.content
        }
    }
}


#Preview {
    EditJournalView(entry: JournalEntry(title: "", content: ""), viewModel: JournalViewModel())
}
