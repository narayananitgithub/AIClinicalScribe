//
//  RecordingView.swift
//  AIClinicalScribe
//
//  Created by Narayanasamy on 11/07/25.
//

import SwiftUI
import AVFoundation

struct RecordingView: View {
    @StateObject private var viewModel = RecordingViewModel()
    @StateObject private var storage = RecordingStorage()
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Header Section
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Recording Session")
                            .foregroundColor(.white)
                        Text("Patient: John Davis")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)
                    }
                    
                    Spacer()
                }

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(.white.opacity(0.8))
                        Text(viewModel.timerText)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    Label(viewModel.isPaused ? "Paused" : "Recording", systemImage: "circle.fill")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(viewModel.isPaused ? Color.yellow.opacity(0.2) : Color.red.opacity(0.2))
                        .foregroundColor(viewModel.isPaused ? .yellow : .red)
                        .clipShape(Capsule())
                }
            }
            .padding()
            .background(Color.blue)
            
            // Main Content ScrollView
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Live Transcription
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Live Transcription")
                            .font(.headline.bold())
                            .foregroundColor(.primary)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(Array(viewModel.liveTranscript.enumerated()), id: \.offset) { _, line in
                                    Text(line)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 120)
                    }
                    .padding()
                    background(Color(hex: "D8D8DA"))
                    .cornerRadius(12)
                    
                    // AI Notes Preview
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("AI Notes Preview")
                                .font(.headline.bold())
                                .foregroundColor(.blue)
                            Spacer()
                            if !viewModel.aiNotes.isEmpty {
                                ProgressView().scaleEffect(0.8)
                            }
                        }
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(viewModel.aiNotes, id: \.self) { line in
                                    Text(line)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 120)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Audio Wave
                    VStack {
                        AudioWaveView(isRecording: !viewModel.isPaused)
                            .frame(height: 80)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding()
            }

            Divider()

            // Bottom Action Buttons
            HStack(spacing: 20) {
                // Play / Pause
                Button(action: viewModel.togglePause) {
                    Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                if viewModel.isPaused {
                    Button(action: {
                        let file = viewModel.stopRecording()
                        storage.addRecording(
                            filename: file.lastPathComponent,
                            transcript: viewModel.liveTranscript.joined(separator: " ")
                        )
                        print("Recording saved successfully: \(file.lastPathComponent)")
                    }) {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                    Button(action: {
                        viewModel.stopRecording()
                        print("Recording discarded")
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
            .background(Color.white)
        }
        .onAppear {
            viewModel.startRecording()
        }
    }
}

#Preview {
    RecordingView()
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
