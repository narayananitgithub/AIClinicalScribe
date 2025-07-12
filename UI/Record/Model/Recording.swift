//
//  Recording.swift
//  AIClinicalScribe
//
//  Created by Narayanasamy on 11/07/25.
//
import SwiftUI
import AVFoundation
import Speech

struct Recording: Identifiable,Codable {
    
    let id: UUID
    let fileName: String
    let transcript: String
    let date: Date
    
    
}
