//
//  WaveformView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 04/10/25.
//

import SwiftUI

struct WaveformView: View {
    @State private var levels: [CGFloat] = Array(repeating: 0.5, count: 15)
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<15, id: \.self) { i in
                Capsule()
                    .fill(Color(red: 0.8, green: 0.4, blue: 0.25))
                    .frame(width: 4, height: levels[i] * 60)
                    .animation(.easeInOut(duration: 0.1), value: levels[i])
            }
        }
        .onReceive(timer) { _ in
            for i in 0..<levels.count {
                levels[i] = CGFloat.random(in: 0.2...1.0)
            }
        }
    }
}

#Preview {
    WaveformView()
}
