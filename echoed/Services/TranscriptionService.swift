//
//  TranscriptionService.swift
//  echoed
//
//  Created by Guilherme Mota on 14/09/2024.
//

import Foundation
import Combine

protocol TranscriptionServiceable {
    func transcribeLastXSeconds(seconds: Int) -> AnyPublisher<String, Never>
}

class TranscriptionService: TranscriptionServiceable  {
    private var cancellables = Set<AnyCancellable>()
    
    func transcribeLastXSeconds(seconds: Int) -> AnyPublisher<String, Never> {
        // Placeholder for the real transcription logic
        // Returning an empty publisher for now to avoid warnings and errors
        return Just("Transcription not implemented yet")
            .eraseToAnyPublisher()
    }
}


class MockTranscriptionService: TranscriptionServiceable  {
    private var cancellables = Set<AnyCancellable>()
    
    func transcribeLastXSeconds(seconds: Int) -> AnyPublisher<String, Never> {
        // Simulating transcription for now (replace with actual transcription logic)
        let simulatedText = "Simulated transcription of last \(seconds) seconds"
        
        return Just(simulatedText)
            .delay(for: .seconds(2), scheduler: RunLoop.main) // Simulate processing delay
            .eraseToAnyPublisher()
    }
    
    // TODO: Add actual audio recording and transcription logic
}
