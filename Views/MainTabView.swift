//
//  MainTabView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            VoiceCaptureView()
                .tabItem {
                    Label("Record", systemImage: "mic.fill")
                }
            
            JournalTimelineView()
                .tabItem {
                    Label("Journal", systemImage: "book.fill")
                }
        }

    }
}

#Preview {
    MainTabView()
}
