//
//  EchoListViewModel.swift
//  echoed
//
//  Created by Guilherme Mota on 25/10/2024.
//

import SwiftUI
import SwiftData
import Combine

class EchoListViewModel: ObservableObject {
    @Published var notes: [TranscribedNote] = []
    @Published var selectedNote: TranscribedNote?
    
    let modelContext: ModelContext
    
    private var cancellables = Set<AnyCancellable>()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadNotes()
    }

    func loadNotes() {
        func loadNotes() {
            // Fetch notes from SwiftData and update the `notes` property.
            do {
                notes = try modelContext.fetch(
                    FetchDescriptor<TranscribedNote>() // Updated to use FetchDescriptor
                )
            } catch {
                print("[EchoListViewModel] | Failed to fetch notes: \(error)")
            }
        }
    }

    func addNote() {
        let newNote = TranscribedNote(timestamp: Date(), text: "New note", duration: 0, isUserEdited: false)
        modelContext.insert(newNote)
        
        do {
            try modelContext.save()
            notes.append(newNote)  // Append the new note to the list
            selectedNote = newNote  // Automatically select the newly created note
        } catch {
            print("Failed to save new note: \(error)")
        }
    }

    func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(notes[index])
        }
        
        do {
            try modelContext.save()
            notes.remove(atOffsets: offsets)
        } catch {
            print("Failed to delete notes: \(error)")
        }
    }
    
    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}
