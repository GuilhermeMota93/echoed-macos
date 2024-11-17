//
//  NoteDetailViewModel.swift
//  echoed
//
//  Created by Guilherme Mota on 16/11/2024.
//

import Foundation
import Combine
import SwiftData

class NoteDetailViewModel: ObservableObject {
    @Published var note: TranscribedNote
    private var transcriptionService: TranscriptionServiceable
    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()

    private let CLIPPED_SECONDS: Int = 30

    init(note: TranscribedNote, modelContext: ModelContext, transcriptionService: TranscriptionServiceable) {
        self.note = note
        self.modelContext = modelContext
        self.transcriptionService = transcriptionService

        // Start the transcription service
        self.startListening()
    }

    deinit {
        // Stop listening when the view model is deallocated
        self.stopListening()
    }

    /// Capture the last 30 seconds and append transcription
    func captureLast30Seconds() {
        transcriptionService
            .transcribeLastXSeconds(seconds: CLIPPED_SECONDS)
            .sink { [weak self] transcribedText in
                guard let self = self else { return }
                let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
                let annotatedText = "[\(timestamp)] \(transcribedText)"
                self.note.content = (self.note.content ?? "") + "\n\(annotatedText)"
                self.saveChanges() // Save content changes
            }
            .store(in: &cancellables)
    }

    /// Save changes to the note
    func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save note: \(error)")
        }
    }

    /// Start continuous listening for audio
    private func startListening() {
        transcriptionService.startListening()
    }

    /// Stop listening for audio
    private func stopListening() {
        transcriptionService.stopListening()
    }
}
