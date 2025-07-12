//
//  RecordingsListView.swift
//  AIClinicalScribe
//
//  Created by Narayanasamy on 11/07/25.
//

import SwiftUI
import AVFoundation
import Speech

struct RecordingsListView: View {
    @ObservedObject var storage = RecordingStorage()

    var body: some View {
        NavigationView {
            List {
                ForEach(storage.recordings) { recording in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(recording.fileName).bold()
                        Text(recording.transcript)
                            .lineLimit(2)
                            .font(.caption)
                        Text(recording.date.formatted())
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let recording = storage.recordings[index]
                        storage.deleteRecording(recording)
                    }
                }
            }
            .navigationTitle("Recordings")
        }
    }
}


#Preview {
    RecordingsListView()
}
