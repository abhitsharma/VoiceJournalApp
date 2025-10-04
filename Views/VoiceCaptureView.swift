//
//  VoiceCaptureView.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI
import SwiftData


struct VoiceCaptureView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = RecordingViewModel()
    @Environment(\.dismiss) private var dismiss

    // MARK: - Main Button Color
    private var mainButtonColor: Color {
        switch viewModel.recordingState {
        case .idle, .completed:
            return Color(red: 0.35, green: 0.35, blue: 0.35)
        case .listening:
            return Color(red: 0.8, green: 0.4, blue: 0.25)
        case .processing:
            return .gray
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.97, blue: 0.95),
                         Color(red: 0.93, green: 0.88, blue: 0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                // MARK: - Transcribed Text
                Text(viewModel.recordingState == .listening || viewModel.recordingState == .completed
                     ? (viewModel.transcribedText.isEmpty ? "Start speaking..." : viewModel.transcribedText)
                     : "Tap the mic to capture your thoughts.")
                    .font(.custom("HelveticaNeue-Light", size: 28))
                    .foregroundColor(viewModel.transcribedText.isEmpty ? .gray : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .transition(.opacity)

                // MARK: - Live Waveform
                if viewModel.recordingState == .listening {
                    WaveformView()
                        .frame(height: 60)
                        .padding(.horizontal, 40)
                        .transition(.opacity)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 60)
                }
                ZStack {
                    Circle()
                        .fill(mainButtonColor.opacity(viewModel.recordingState == .listening ? 0.4 : 0))
                        .frame(width: 120, height: 120)
                        .scaleEffect(viewModel.recordingState == .listening ? 1.3 : 1)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: viewModel.recordingState)

                    // Mic Button
                    Button(action: handleMicTap) {
                        Image(systemName: viewModel.recordingState == .listening ? "stop.fill" : "mic.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                            .padding(30)
                            .background(mainButtonColor)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .scaleEffect(viewModel.recordingState == .listening ? 1.1 : 1)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.recordingState)
                    }
                }
                .padding(.vertical, 30)

                HStack(spacing: 100) {
                    // Cancel Button
                    Button(action: {
                        viewModel.reset()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color(red: 178/255, green: 42/255, blue: 0/255).opacity(0.9))
                            .clipShape(Circle())
                    }
                    .opacity(viewModel.recordingState != .idle ? 1 : 0)
                    .disabled(viewModel.recordingState == .idle)

                    // Done / Save Button
                    Button(action: {
                        if viewModel.recordingState == .listening {
                            viewModel.stopRecording()
                        } else if viewModel.recordingState == .completed && !viewModel.transcribedText.isEmpty {
                            saveEntry()
                        }
                    }) {
                        Image(systemName: viewModel.recordingState == .listening ? "square.fill" : "checkmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color(red: 97/255, green: 136/255, blue: 51/255).opacity(0.9))
                            .clipShape(Circle())
                    }
                    .opacity(viewModel.recordingState != .idle ? 1 : 0)
                    .disabled(viewModel.recordingState == .idle)
                }
                .padding(.bottom, 30)


            }
        }
    }

    // MARK: - Actions
    private func handleMicTap() {
        switch viewModel.recordingState {
        case .idle:
            viewModel.startRecording()
        case .listening:
            viewModel.stopRecording()
        case .completed:
            break
        case .processing:
            break
        }
    }

    private func saveEntry() {
        let entry = JournalEntry(
            title: viewModel.generatedTitle,
            content: viewModel.transcribedText,
            createdAt: Date(),
            updatedAt: Date()
        )
        modelContext.insert(entry)
        try? modelContext.save()
        viewModel.reset()
        dismiss()
    }
}



#Preview {
    VoiceCaptureView()
}
