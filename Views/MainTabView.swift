//
//  MainTabView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI


// MARK: - MainTabView
struct MainTabView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                VoiceCaptureView()
                    .tag(0)
                JournalTimelineView()
                    .tag(1)
            }

            // Floating custom tab bar
            HStack {
                Spacer()
                TabButton(
                    icon: "mic.fill",
                    title: "Record",
                    isSelected: selectedTab == 0,
                    selectedColor: Color(red: 0.8, green: 0.4, blue: 0.25), // material indigo
                    unselectedColor: Color(white: 0.6)
                ) {
                    withAnimation(.spring()) { selectedTab = 0 }
                }

                Spacer()

                TabButton(
                    icon: "book.fill",
                    title: "Journal",
                    isSelected: selectedTab == 1,
                    selectedColor: Color(red: 0.8, green: 0.4, blue: 0.25),
                    unselectedColor: Color(white: 0.6)
                ) {
                    withAnimation(.spring()) { selectedTab = 1 }
                }

                Spacer()
            }
            .padding(.vertical, 12)
            .background(.regularMaterial) // floating blur / material
            .cornerRadius(28)
            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 6)
            .padding(.horizontal, 36)
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}


#Preview {
    MainTabView()
}
