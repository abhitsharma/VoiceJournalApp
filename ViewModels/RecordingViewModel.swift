//
//  RecordingViewModel.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI
import AVFoundation
import Speech
import ActivityKit

@Observable
class RecordingViewModel: NSObject {
    
    var recordingState: RecordingState = .idle
    var transcribedText: String = ""
    var generatedTitle: String = ""
    
    private var activity: Activity<RecordingActivityAttributes>?
    private var startDate: Date?
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    
    // MARK: - Permissions
    func requestPermissions(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(authStatus == .authorized && granted)
                }
            }
        }
    }
    
    // MARK: - Recording Control
    func startRecording() {
        guard recordingState == .idle else { return }
        
        recordingState = .listening
        transcribedText = ""
        generatedTitle = ""
        
        startLiveActivity()
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        guard let recognitionRequest else { return }
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.transcribedText = result.bestTranscription.formattedString
            }
            if let error = error {
                self.handleError(error)
            }
            if result?.isFinal == true {
                self.stopRecording()
            }
        }
        
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    func stopRecording() {
        recordingState = .processing
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionTask?.finish()
        recognitionTask = nil
        recognitionRequest = nil
        
        generatedTitle = generateTitle(from: transcribedText)
        recordingState = .completed
        
        stopLiveActivity()
    }
    
    func reset() {
        recordingState = .idle
        transcribedText = ""
        generatedTitle = ""
    }
    
    // MARK: - Helpers
    private func generateTitle(from text: String) -> String {
        let words = text.split(separator: " ")
        let firstWords = words.prefix(6).joined(separator: " ")
        return firstWords.isEmpty ? "New Entry" : firstWords
    }
    
    private func handleError(_ error: Error) {
        print("Speech recognition error: \(error.localizedDescription)")
        reset()
        stopLiveActivity()
    }
    
    // MARK: - Live Activities
    private func startLiveActivity() {
        let attributes = RecordingActivityAttributes(name: "Voice Journal")
        let initialState = RecordingActivityAttributes.ContentState(isRecording: true, elapsedTime: 0)
        
        do {
            activity = try Activity.request(attributes: attributes, contentState: initialState, pushType: nil)
            startDate = Date()
            print("✅ Live Activity started")
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
        }
    }
    
    func updateLiveActivity() {
        guard let activity = activity, let startDate = startDate else { return }
        let elapsed = Date().timeIntervalSince(startDate)
        
        Task {
            let updatedState = RecordingActivityAttributes.ContentState(isRecording: true, elapsedTime: elapsed)
            await activity.update(using: updatedState)
        }
    }
    
    private func stopLiveActivity() {
        guard let activity = activity, let startDate = startDate else { return }
        let elapsed = Date().timeIntervalSince(startDate)
        
        Task {
            let endState = RecordingActivityAttributes.ContentState(isRecording: false, elapsedTime: elapsed)
            await activity.end(using: endState, dismissalPolicy: .immediate)
            self.activity = nil
            print("🛑 Live Activity stopped")
        }
    }
}
