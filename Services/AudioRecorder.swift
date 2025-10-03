//
//  AudioRecorder.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import Foundation
import AVFoundation

final class AudioRecorder {
    private let audioEngine = AVAudioEngine()
    
    func startRecording(onBuffer: @escaping (AVAudioPCMBuffer) -> Void) throws {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            onBuffer(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
