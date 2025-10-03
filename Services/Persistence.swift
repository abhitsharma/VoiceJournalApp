//
//  Persistence.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import Foundation
import SwiftData

@MainActor
final class Persistence {
    static let shared = Persistence()
    
    let container: ModelContainer
    
    private init() {
        do {
            container = try ModelContainer(for: JournalEntry.self)
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
    
    var context: ModelContext {
        container.mainContext
    }
    
    func save() {
        try? context.save()
    }
}
