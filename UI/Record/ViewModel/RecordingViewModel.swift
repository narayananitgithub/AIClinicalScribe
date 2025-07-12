//
//  RecordingViewModel.swift
//  AIClinicalScribe
//
//  Created by Narayanasamy on 11/07/25.
//

import Foundation
import AVFoundation

class RecordingViewModel: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isPaused = false
    @Published var timerText = "00:00"
    @Published var liveTranscript: [String] = []
    @Published var aiNotes = [
        "S: Patient reporting back pain symptoms",
        "O: Initial examination in progress",
        "A: Gathering data for assessment",
        "P: Will formulate based on findings"
    ]

    private var recorder: AVAudioRecorder?
    private var timer: Timer?
    private var seconds = 0
    private var fileURL: URL?

    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default)
        try? session.setActive(true)

        let filename = UUID().uuidString + ".m4a"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        recorder = try? AVAudioRecorder(url: path, settings: settings)
        recorder?.delegate = self
        recorder?.record()

        fileURL = path
        startTimer()
    }

    func stopRecording() -> URL {
        recorder?.stop()
        timer?.invalidate()
        return fileURL ?? URL(fileURLWithPath: "")
    }

    func togglePause() {
        isPaused.toggle()
        if isPaused {
            recorder?.pause()
        } else {
            recorder?.record()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.seconds += 1
            let min = String(format: "%02d", self.seconds / 60)
            let sec = String(format: "%02d", self.seconds % 60)
            self.timerText = "\(min):\(sec)"
            
            if !self.isPaused {
                // Add realistic medical transcription data every few seconds
                let transcriptLines = [
                    "Patient reports lower back pain for the past 3 weeks",
                    "Pain level ranges from 4 to 7 out of 10 on the pain scale",
                    "Taking ibuprofen 400mg twice daily for pain management",
                    "No radiating pain down the legs reported",
                    "Patient works as a construction worker, heavy lifting involved",
                    "Morning stiffness lasts approximately 30 minutes",
                    "Currently taking lisinopril 10mg daily for hypertension",
                    "Occupation involves prolonged standing and bending",
                    "Patient drinks 2-3 cups of coffee daily, no alcohol",
                    "Last blood work done 6 months ago, all values normal",
                    "Patient exercises 3 times per week when able",
                    "No recent weight loss or gain reported"
                ]
                
                // Add a new line every 3-5 seconds with some randomness
                if self.seconds % Int.random(in: 3...5) == 0 {
                    let randomIndex = Int.random(in: 0..<transcriptLines.count)
                    self.liveTranscript.append(transcriptLines[randomIndex])
                }
            }
        }
    }
}
