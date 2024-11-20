//
//  ContentViewModel.swift
//  SkullAR
//
//  Created by ILB on 20/11/24.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    @Published var transcript: String = ""
    @Published var isRecording: Bool = false
    @Published var selectedModelURL: URL? = nil
    @Published var errorMessage: String? = nil
    
    private let speechManager = SpeechManager()
    private let modelManager = ARModelManager.shared
    
    var models: [ARModel] { modelManager.getAllModels() }
    
    init() {
        speechManager.checkPermissions()
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    //MARK: Speech functions here
    private func startRecording() {
        do {
            try speechManager.startRecording { [weak self] transcription in
                DispatchQueue.main.async {
                    self?.transcript = transcription
                    self?.checkForModelMatch(in: transcription)
                }
            }
            isRecording = true
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() {
        speechManager.stopRecording()
        isRecording = false
    }
    
    //MARK: Retrieveing 3D model here
    private func checkForModelMatch(in transcript: String) {
        if let model = modelManager.findModel(byVoiceInput: transcript) {
            selectedModelURL = model.url
        }
    }
}
