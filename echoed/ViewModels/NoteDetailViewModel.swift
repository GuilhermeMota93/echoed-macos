//
//  NoteDetailViewModel.swift
//  echoed
//
//  Created by Guilherme Mota on 16/11/2024.
//

import Foundation
import Combine

class NoteDetailViewModel: ObservableObject {
    @Published var noteContent: String

    private var note: TranscribedNote
    private var transcriptionService: TranscriptionServiceable
    private var cancellables = Set<AnyCancellable>()
    
    private let CLIPPED_SECONDS: Int = 30

    init(note: TranscribedNote, transcriptionService: TranscriptionServiceable) {
        self.note = note
        self.transcriptionService = transcriptionService
        self.noteContent = note.content ?? ""
    }

    /// Capture the last 30 seconds and append transcription
    func captureLast30Seconds() {
        transcriptionService
            .transcribeLastXSeconds(seconds: CLIPPED_SECONDS)
            .sink { [weak self] transcribedText in
                guard let self = self else { return }
                let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
                let annotatedText = "[\(timestamp)] \(transcribedText)"
                self.noteContent += "\n\(annotatedText)"
            }
            .store(in: &cancellables)
    }
}
