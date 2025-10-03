//
//  RecordingViewModel.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI
import AVFoundation
import Speech

@Observable
class RecordingViewModel: NSObject, AVAudioRecorderDelegate {
    var recordingState: RecordingState = .idle
    var transcribedText: String = ""
    var generatedTitle: String = ""
    
    private var audioRecorder: AVAudioRecorder?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // MARK: - Recording Control
    
    func startRecording() {
        recordingState = .listening
        transcribedText = ""
        generatedTitle = ""
        
        // Setup audio session
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.transcribedText = result.bestTranscription.formattedString
            }
            
            if error != nil || (result?.isFinal ?? false) {
                self.stopRecording()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
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
        recognitionTask?.cancel()
        
        // Generate title (basic fallback)
        generatedTitle = generateTitle(from: transcribedText)
        recordingState = .completed
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
}
