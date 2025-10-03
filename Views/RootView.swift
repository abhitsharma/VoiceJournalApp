//
//  RootView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

       var body: some View {
           if hasCompletedOnboarding {
               MainTabView() // your main app view (VoiceCapture + Timeline)
           } else {
               OnboardingView()
           }
       }
}

#Preview {
    RootView()
}
