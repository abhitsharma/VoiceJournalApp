//
//  SaveButton.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI

struct SaveButton: View {
    var action: () -> Void
    @State private var animate = false

    var body: some View {
        Button {
            action()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                animate = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animate = false
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } label: {
            Text("Save")
                .font(.headline)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .cornerRadius(12)
                .scaleEffect(animate ? 1.1 : 1)
        }
    }
}


#Preview {
    SaveButton(action: {})
}
