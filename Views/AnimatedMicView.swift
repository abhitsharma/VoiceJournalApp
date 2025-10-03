//
//  AnimatedMicView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI

struct AnimatedMicView: View {
    var isRecording: Bool
    var level: CGFloat // 0...1 audio level

    var body: some View {
        ZStack {
            Circle()
                .fill(isRecording
                      ? AnyShapeStyle(.red.gradient)
                      : AnyShapeStyle(.blue.gradient))
                .frame(width: 140 + level * 40,
                       height: 140 + level * 40)
                .shadow(radius: 10)
                .animation(.easeInOut(duration: 0.2), value: level)

            Image(systemName: isRecording ? "waveform.circle.fill" : "mic.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(.white)
                .shadow(radius: 4)
        }
    }
}


#Preview {
    AnimatedMicView(isRecording: false, level: 0)
}
