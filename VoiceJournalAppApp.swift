//
//  VoiceJournalAppApp.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI

@main
struct VoiceJournalAppApp: App {
    let persistence = Persistence.shared
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1.0) // navigation bar background
        appearance.titleTextAttributes = [.foregroundColor: UIColor(red: 0.8, green: 0.4, blue: 0.25, alpha: 1.0)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.8, green: 0.4, blue: 0.25, alpha: 1.0)]
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(red: 0.8, green: 0.4, blue: 0.25, alpha: 1.0)]
        let backImage = UIImage(systemName: "chevron.left")?.withTintColor(
            UIColor(red: 0.8, green: 0.4, blue: 0.25, alpha: 1.0),
            renderingMode: .alwaysOriginal
        )
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(red: 0.8, green: 0.4, blue: 0.25, alpha: 1.0)
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContext(persistence.container.mainContext)
        }
    }
}
