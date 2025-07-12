//
//  AudioWaveView.swift
//  AIClinicalScribe
//
//  Created by Narayanasamy on 11/07/25.
//

import SwiftUI



struct AudioWaveView: View {
    let isRecording: Bool
    @State private var animationValues: [Double] = Array(repeating: 0.1, count: 12)
    @State private var timer: Timer?
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<12, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(width: 6, height: CGFloat(animationValues[index] * 40))
                    .animation(.easeInOut(duration: 0.5), value: animationValues[index])
            }
        }
        .frame(height: 50)
        .onAppear {
            startWaveAnimation()
        }
        .onDisappear {
            stopWaveAnimation()
        }
        .onChange(of: isRecording) { recording in
            if recording {
                startWaveAnimation()
            } else {
                stopWaveAnimation()
            }
        }
    }
    
    private func startWaveAnimation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation {
                for i in 0..<animationValues.count {
                    animationValues[i] = Double.random(in: 0.3...1.0)
                }
            }
        }
    }
    
    private func stopWaveAnimation() {
        timer?.invalidate()
        timer = nil
        withAnimation {
            for i in 0..<animationValues.count {
                animationValues[i] = 0.1
            }
        }
    }
}
//#Preview {
//    AudioWaveView()
//}
