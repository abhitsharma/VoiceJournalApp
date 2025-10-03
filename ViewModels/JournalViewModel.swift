//
//  JournalViewModel.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI
import SwiftData

@Observable
class JournalViewModel {
    var entries: [JournalEntry] = []
    var context: ModelContext?
    
    init(context: ModelContext? = nil) {
        self.context = context
        loadEntries()
    }
    
    func setContext(_ context: ModelContext) {
        self.context = context
        loadEntries()
    }
    
    func loadEntries() {
        guard let context else { return }
        let descriptor = FetchDescriptor<JournalEntry>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        entries = (try? context.fetch(descriptor)) ?? []
    }
    
    func addEntry(title: String, content: String) {
        guard let context else { return }
        let entry = JournalEntry(title: title, content: content)
        context.insert(entry)
        try? context.save()
        loadEntries()
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        guard let context else { return }
        context.delete(entry)
        try? context.save()
        loadEntries()
    }
}
