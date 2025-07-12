//
//  Recordingstorage.swift
//  AIClinicalScribe
//
//  Created by Narayanasamy on 11/07/25.
//

import SwiftUI
import AVFoundation
import Foundation


struct Recording: Identifiable, Codable {
    let id: UUID
    let fileName: String
    let transcript: String
    let date: Date
}

class RecordingStorage: ObservableObject {
    @Published var recordings: [Recording] = []
    
    private let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recordings.json")
    
    init() {
        load()
    }
    
    func addRecording(filename: String, transcript: String) {
        let newRecording = Recording(id: UUID(), fileName: filename, transcript: transcript, date: Date())
        recordings.append(newRecording)
        save()
        print("Recording added: \(filename) - Total recordings: \(recordings.count)")
    }
    
    func deleteRecording(_ recording: Recording) {
        recordings.removeAll { $0.id == recording.id }
        try? FileManager.default.removeItem(at: audioURL(for: recording.fileName))
        save()
    }

    func audioURL(for filename: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(recordings) {
            try? data.write(to: savePath)
            print("Recordings saved to: \(savePath)")
        }
    }

    private func load() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Recording].self, from: data) {
                recordings = decoded
                print("Loaded \(recordings.count) recordings from storage")
            }
        }
    }
}
