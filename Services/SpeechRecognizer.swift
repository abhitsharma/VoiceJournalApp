//
//  SpeechRecognizer.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import Foundation
import Speech
import AVFoundation

final class SpeechRecognizer {
    private let recognizer: SFSpeechRecognizer?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    init(locale: Locale = Locale(identifier: "en-US")) {
        self.recognizer = SFSpeechRecognizer(locale: locale)
    }
    
    func requestAuthorization(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }
    
    func startRecognition(onText: @escaping (String, Bool) -> Void) -> SFSpeechAudioBufferRecognitionRequest? {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest, let recognizer = recognizer else { return nil }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                onText(result.bestTranscription.formattedString, result.isFinal)
            }
            
            if error != nil || (result?.isFinal ?? false) {
                self.stopRecognition()
            }
        }
        
        return recognitionRequest
    }
    
    func stopRecognition() {
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
    }
}
