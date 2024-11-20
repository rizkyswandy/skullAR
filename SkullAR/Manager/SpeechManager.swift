//
//  SpeechManager.swift
//  SkullAR
//
//  Created by ILB on 20/11/24.
//

import Speech
import AVFoundation

enum SpeechStatus {
    case unavailable
    case denied
    case restricted
    case authorized
    case notDetermined
}

class SpeechManager: NSObject, ObservableObject {
    typealias TranscriptionCallback = (String) -> Void
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @Published var authorizationStatus: SpeechStatus = .notDetermined
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
        checkPermissions()
    }
    
    func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self?.authorizationStatus = .authorized
                case .denied:
                    self?.authorizationStatus = .denied
                case .restricted:
                    self?.authorizationStatus = .restricted
                case .notDetermined:
                    self?.authorizationStatus = .notDetermined
                @unknown default:
                    self?.authorizationStatus = .unavailable
                }
            }
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            print("Microphone permission granted: \(granted)")
        }
    }
    
    func startRecording(callback: @escaping TranscriptionCallback) throws {
        // First check authorization
        guard authorizationStatus == .authorized else {
            throw NSError(domain: "", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Speech recognition not authorized"])
        }
        
        // Ensure previous session is stopped
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { result, error in
            if let result = result {
                callback(result.bestTranscription.formattedString)
            }
            
            if error != nil {
                self.stopRecording()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
    }
}

extension SpeechManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            authorizationStatus = .unavailable
        }
    }
}
