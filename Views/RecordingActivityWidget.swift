//
//  RecordingActivity.swift
//  VoiceJournalApp
//
//  Created by Abhit Sharma on 03/10/25.
//

import SwiftUI
import ActivityKit
import WidgetKit


struct RecordingActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isRecording: Bool
        var elapsedTime: TimeInterval
    }

    var name: String
}



struct RecordingActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RecordingActivityAttributes.self) { context in
            // 🔹 Lock screen / Notification view
            VStack {
                if context.state.isRecording {
                    Text("🎙️ Recording…")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text("Elapsed: \(Int(context.state.elapsedTime))s")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Recording stopped")
                        .font(.headline)
                }
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                // 🔹 Expanded view
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        Text(context.state.isRecording ? "Recording…" : "Stopped")
                            .font(.headline)
                        Text("Elapsed: \(Int(context.state.elapsedTime))s")
                            .font(.caption)
                    }
                }
            } compactLeading: {
                Image(systemName: context.state.isRecording ? "mic.fill" : "stop.fill")
                    .foregroundColor(.red)
            } compactTrailing: {
                Text("\(Int(context.state.elapsedTime))s")
            } minimal: {
                Image(systemName: context.state.isRecording ? "mic.fill" : "stop.fill")
            }
        }
    }
}


