//
//  VoiceCaptureView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI

struct VoiceCaptureView: View {
    @State private var isRecording = false
    @State private var transcription = ""
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated Orb / Waveform
            Circle()
                .fill(isRecording ? Color.red : Color.blue)
                .frame(width: isRecording ? 180 : 120, height: isRecording ? 180 : 120)
                .shadow(radius: 10)
                .scaleEffect(isRecording ? 1.2 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isRecording)
            
            Text(isRecording ? "Listening..." : "Tap to Record")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Button {
                isRecording.toggle()
                // TODO: integrate AudioRecorderService
            } label: {
                Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(isRecording ? .red : .blue)
            }
            
            Spacer()
            
            if !transcription.isEmpty {
                VStack(alignment: .leading) {
                    Text("Preview")
                        .font(.headline)
                    Text(transcription)
                        .font(.body)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    VoiceCaptureView()
}
