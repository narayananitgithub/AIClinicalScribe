# 🎙️ Audio Recorder & Transcription App (iOS – SwiftUI)

A mobile app prototype demonstrating real-time audio recording, live transcription (mock), and local storage capabilities. Built using **SwiftUI** with a modern and clean UI that replicates the provided screen mockup.

---

## 📱 Features

- 🎬 **Recording Session Interface**  
  - Session header with timer  
  - "Recording"/"Paused" status indicator  
  - Live transcription panel (mock data)  
  - Optional audio waveform visualizer  

- ⏺️ **Start/Pause/Stop Controls**  
  - Begin recording with the "Start" button  
  - Pause/resume functionality  
  - Stop to save recording and transcript  

- 📄 **Transcription**  
  - Live display of dummy transcription text  
  - Transcript stored as plain text/JSON  

- 💾 **Local Data Management**  
  - Stores audio recordings using `AVAudioRecorder`  
  - Stores transcript files locally (can be viewed/deleted)

- ☁️ **Bonus (if implemented)**  
  - HTTP upload to a remote endpoint (placeholder setup)
  - Speech-to-text using iOS Speech framework

---

## 🚀 How to Run the App

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/RecordingApp.git
