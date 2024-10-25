//
//  FloatingNoteViewModel.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import Foundation
import Combine
import SwiftData

struct Transcription: Hashable, Identifiable {
    let id = UUID()
    let timestamp: String
    var text: String
    var editableText: String
    
    init(text: String, timestamp: String) {
        self.text = text
        self.timestamp = timestamp
        self.editableText = text
    }
}

//class FloatingNoteViewModel: ObservableObject {
//    @Published var transcriptions: [Transcription] = []
//    @Published var isRecording: Bool = false
//    @Published var autoSaveMessage: String = ""
//    
//    private let defaultMessage: String = "Changes will save automatically"
//    private let defaultRecordedSeconds: Int = 10
//    
//    private var cancellables = Set<AnyCancellable>()
//    private let transcriptionService: TranscriptionServiceable
//    private var resetAutoSaveMessageCancellable: AnyCancellable?
//    
//    init(transcriptionService: TranscriptionServiceable) {
//        self.transcriptionService = transcriptionService
//        autoSaveMessage = defaultMessage
//        setupAutoSaveThrottle()
//    }
//    
//    func toggleRecording() {
//        if isRecording {
//            stopRecording()
//        } else {
//            startTranscription()
//        }
//        isRecording.toggle()
//    }
//    
//    private func startTranscription() {
//        transcriptionService.transcribeLastXSeconds(seconds: defaultRecordedSeconds)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                if case .failure(let error) = completion {
//                    print("Transcription failed: \(error)")
//                    self?.isRecording = false
//                }
//            }, receiveValue: { [weak self] text in
//                guard let self = self else { return }
//                let timestamp = self.getCurrentTimeStamp()
//                
//                let newTranscription = Transcription(text: text, timestamp: timestamp)
//                self.transcriptions.append(newTranscription)
//                
//                self.autoSaveMessage = "Auto-saved"
//                self.resetAutoSaveMessageAfterDelay()
//                self.isRecording = false
//            })
//            .store(in: &cancellables)
//    }
//    
//    private func stopRecording() {
//        //TODO: Stop recording functionality
//    }
//    
//    private func setupAutoSaveThrottle() {
//        $transcriptions
//            .debounce(for: .seconds(2), scheduler: RunLoop.main)
//            .sink { [weak self] _ in
//                self?.saveNote()
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func saveNote() {
//        autoSaveMessage = defaultMessage
//        resetAutoSaveMessageAfterDelay()
//    }
//    
//    private func resetAutoSaveMessageAfterDelay() {
//        resetAutoSaveMessageCancellable?.cancel()
//        resetAutoSaveMessageCancellable = Just(())
//            .delay(for: .seconds(2), scheduler: RunLoop.main)
//            .sink { [weak self] in
//                guard let self = self else { return }
//                self.autoSaveMessage = self.defaultMessage
//            }
//    }
//    
//    private func getCurrentTimeStamp() -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .medium
//        return formatter.string(from: Date())
//    }
//}


class FloatingNoteViewModel: ObservableObject {
    @Published var transcriptions: [Transcription] = []
    @Published var isRecording: Bool = false
    @Published var autoSaveMessage: String = ""
    
    private let defaultMessage: String = "Changes will save automatically"
    private let defaultRecordedSeconds: Int = 10
    
    private var cancellables = Set<AnyCancellable>()
    private let transcriptionService: TranscriptionServiceable
    private var resetAutoSaveMessageCancellable: AnyCancellable?
    private let modelContext: ModelContext  // Added ModelContext

    init(transcriptionService: TranscriptionServiceable, modelContext: ModelContext) {
        self.transcriptionService = transcriptionService
        self.modelContext = modelContext
        autoSaveMessage = defaultMessage
        setupAutoSaveThrottle()
    }

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startTranscription()
        }
        isRecording.toggle()
    }

    private func startTranscription() {
        transcriptionService.transcribeLastXSeconds(seconds: defaultRecordedSeconds)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Transcription failed: \(error)")
                    self?.isRecording = false
                }
            }, receiveValue: { [weak self] text in
                guard let self = self else { return }
                let timestamp = self.getCurrentTimeStamp()

                let newTranscription = Transcription(text: text, timestamp: timestamp)
                self.transcriptions.append(newTranscription)

                // Save to SwiftData
                self.saveTranscription(text: text, timestamp: timestamp)

                self.autoSaveMessage = "Auto-saved"
                self.resetAutoSaveMessageAfterDelay()
                self.isRecording = false
            })
            .store(in: &cancellables)
    }

    private func stopRecording() {
        //TODO: Stop recording functionality
    }

    private func setupAutoSaveThrottle() {
        $transcriptions
            .debounce(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveNote()
            }
            .store(in: &cancellables)
    }

    private func saveNote() {
        autoSaveMessage = defaultMessage
        resetAutoSaveMessageAfterDelay()
    }

    private func saveTranscription(text: String, timestamp: String) {
        let transcribedNote = TranscribedNote(
            timestamp: Date(),
            text: text,
            duration: TimeInterval(defaultRecordedSeconds),
            isUserEdited: false
        )

        // Insert into the SwiftData context
        modelContext.insert(transcribedNote)

        // Save the changes
        do {
            try modelContext.save()
        } catch {
            print("Failed to save transcription: \(error)")
        }
    }

    private func resetAutoSaveMessageAfterDelay() {
        resetAutoSaveMessageCancellable?.cancel()
        resetAutoSaveMessageCancellable = Just(())
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.autoSaveMessage = self.defaultMessage
            }
    }

    private func getCurrentTimeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: Date())
    }
}
