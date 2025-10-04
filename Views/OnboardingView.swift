//
//  OnboardingView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.97, blue: 0.95),
                         Color(red: 0.93, green: 0.88, blue: 0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App Icon / Illustration
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 200, height: 200)
                        .blur(radius: 8)
                    Image(systemName: "mic.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundStyle(Color(red: 0.8, green: 0.4, blue: 0.25))
                }
                
                VStack(spacing: 16) {
                    Text("🎙️ Welcome to VoiceJournal")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                    
                    Text("Capture your thoughts effortlessly by speaking them out loud. We'll transcribe and save them for you.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black.opacity(0.85))
                        .padding(.horizontal, 30)
                }
                
                Spacer()
                
                // CTA Button
                Button(action: {
                    hasCompletedOnboarding = true
                }) {
                    Text("Get Started")
                        .font(.headline.bold())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.8, green: 0.4, blue: 0.25))
                        .foregroundStyle(.white)
                        .cornerRadius(16)
                        .shadow(radius: 6)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
