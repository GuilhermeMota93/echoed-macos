//
//  TranscriptionService.swift
//  echoed
//
//  Created by Guilherme Mota on 14/09/2024.
//

import Foundation
import Combine

protocol TranscriptionServiceable {
    func startListening() // Starts listening for audio
    func stopListening() // Stops listening
    func transcribeLastXSeconds(seconds: Int) -> AnyPublisher<String, Never> // Transcribes audio
}

class TranscriptionService: TranscriptionServiceable {
    private var cancellables = Set<AnyCancellable>()
    private var audioBuffer: [String] = [] // Mock buffer storing chunks of audio transcriptions
    private let bufferLimit = 30 // Maximum seconds to keep in the buffer
    
    private var isListening = false
    
    func startListening() {
        guard !isListening else { return }
        isListening = true
        
        // Simulate continuous audio capture (replace with actual audio recording logic)
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.captureAudioChunk("Simulated audio chunk at \(Date())")
            }
            .store(in: &cancellables)
    }
    
    func stopListening() {
        isListening = false
        cancellables.removeAll()
    }
    
    private func captureAudioChunk(_ chunk: String) {
        audioBuffer.append(chunk)
        
        // Maintain a rolling buffer of the last N seconds
        if audioBuffer.count > bufferLimit {
            audioBuffer.removeFirst(audioBuffer.count - bufferLimit)
        }
    }
    
    func transcribeLastXSeconds(seconds: Int) -> AnyPublisher<String, Never> {
        guard seconds <= bufferLimit else {
            return Just("Error: Cannot transcribe more than \(bufferLimit) seconds.")
                .eraseToAnyPublisher()
        }
        
        // Simulate transcription process (replace with actual transcription logic)
        let transcription = audioBuffer.suffix(seconds).joined(separator: " ")
        return Just(transcription)
            .delay(for: .seconds(2), scheduler: RunLoop.main) // Simulate processing time
            .eraseToAnyPublisher()
    }
}

class MockTranscriptionService: TranscriptionServiceable {
    private var cancellables = Set<AnyCancellable>()
    private var simulatedBuffer: [String] = Array(repeating: "Mock audio", count: 30)

    func startListening() {
        print("Mock listening started.")
    }

    func stopListening() {
        print("Mock listening stopped.")
    }

    func transcribeLastXSeconds(seconds: Int) -> AnyPublisher<String, Never> {
        let transcription = simulatedBuffer.suffix(seconds).joined(separator: " ")
        return Just(transcription)
            .delay(for: .seconds(1), scheduler: RunLoop.main) // Simulate processing delay
            .eraseToAnyPublisher()
    }
}
