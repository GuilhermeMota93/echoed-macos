//
//  EchoListViewModel.swift
//  echoed
//
//  Created by Guilherme Mota on 25/10/2024.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
class EchoListViewModel: ObservableObject {
    var modelContext: ModelContext {
        didSet {
            fetchNotes()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    @Published var notes: [TranscribedNote] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchNotes()
        
//        modelContext.objectWillChange
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.fetchNotes()
//            }
//            .store(in: &cancellables)
    }
    
    func fetchNotes() {
        let fetchDescriptor = FetchDescriptor<TranscribedNote>()
        do {
            notes = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }
    
    func addNote(title: String, content: String) {
        let newNote = TranscribedNote(title: title, content: content)
        modelContext.insert(newNote)
        saveContext()
    }
    
    func deleteNote(_ note: TranscribedNote) {
        modelContext.delete(note)
        saveContext()
    }
    
    func deleteNotes(at offsets: IndexSet) {
        offsets.forEach { index in
            let note = notes[index]
            modelContext.delete(note)
        }
        saveContext()
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
