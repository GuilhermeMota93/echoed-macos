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
    @Published var selectedNote: TranscribedNote? = nil
    @Published var selectedForBulkDelete: Set<TranscribedNote> = []
    @Published var isShowingDeleteConfirmation = false
    @Published var notes: [TranscribedNote] = [] // Fetched notes
    @Published var lastSelectedNote: TranscribedNote? = nil // Track the last selected note for range selection

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchNotes()
    }

    func fetchNotes() {
        let fetchDescriptor = FetchDescriptor<TranscribedNote>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        do {
            notes = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch notes: \(error)")
            notes = []
        }
    }

    func addNewNote() {
        let newNote = TranscribedNote(title: "New Note", timestamp: Date())
        modelContext.insert(newNote)

        do {
            try modelContext.save()
            fetchNotes()
            selectedNote = newNote
        } catch {
            print("Failed to save new note: \(error)")
        }
    }

    func deleteNotes(_ notesToDelete: Set<TranscribedNote>) {
        notesToDelete.forEach { modelContext.delete($0) }

        do {
            try modelContext.save()
            fetchNotes()
            selectedNote = nil
            selectedForBulkDelete.removeAll()
        } catch {
            print("Failed to delete notes: \(error)")
        }
    }

    /// Single selection
    func selectSingle(note: TranscribedNote) {
        selectedNote = note
        selectedForBulkDelete = [note]
        lastSelectedNote = note
    }

    /// Range selection (Shift-click)
    func selectRange(from startNote: TranscribedNote?, to endNote: TranscribedNote) {
        guard let startNote = startNote else {
            selectedForBulkDelete.insert(endNote)
            lastSelectedNote = endNote
            return
        }

        if let startIndex = notes.firstIndex(of: startNote),
           let endIndex = notes.firstIndex(of: endNote) {
            let range = startIndex < endIndex
                ? notes[startIndex...endIndex]
                : notes[endIndex...startIndex]

            selectedForBulkDelete.formUnion(range)
            lastSelectedNote = endNote
        }
    }

    /// Toggle selection of a single note (Cmd-click)
    func toggleSelection(note: TranscribedNote) {
        if selectedForBulkDelete.contains(note) {
            selectedForBulkDelete.remove(note)
        } else {
            selectedForBulkDelete.insert(note)
        }
    }

    func confirmBulkDelete() {
        isShowingDeleteConfirmation = true
    }

    func backgroundColor(for note: TranscribedNote) -> Color {
        if selectedForBulkDelete.contains(note) {
            return Color.blue.opacity(0.2)
        } else {
            return Color.clear
        }
    }
}
