//
//  TitleGenerator.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import Foundation

final class TitleGenerator {
    
    /// Generate a title either from first few words or fallback.
    func generate(from text: String) -> String {
        let words = text.split(separator: " ")
        let firstWords = words.prefix(6).joined(separator: " ")
        return firstWords.isEmpty ? "New Entry" : firstWords
    }
    
    /// Future: Add AI/WritingTools API integration here
    func generateWithAPI(from text: String, completion: @escaping (String) -> Void) {
        // Placeholder for API request
        // For now, just call local method
        completion(generate(from: text))
    }
}
