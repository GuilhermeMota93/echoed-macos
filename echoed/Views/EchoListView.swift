//
//  ContentView.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData

struct EchoListView: View {
    @Query(sort: \TranscribedNote.timestamp, order: .reverse) var notes: [TranscribedNote]
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedNote: TranscribedNote? = nil
    @State private var selectedForBulkDelete: Set<TranscribedNote> = [] // Track multi-selected notes
    @State private var lastSelectedNote: TranscribedNote? = nil // Track the last clicked note for Shift-click logic
    @State private var isShowingDeleteConfirmation = false // For delete confirmation
    
    var body: some View {
        NavigationSplitView {
            // Sidebar with note list
            List(selection: $selectedNote) {
                ForEach(notes) { note in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.timestamp, format: .dateTime)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure row spans full width
                    .padding(.horizontal, 4)
                    .background(backgroundColor(for: note)) // Dynamic background color
                    .cornerRadius(8)
                    .contentShape(Rectangle()) // Makes the entire row tappable
                    .onTapGesture {
                        detectModifiersAndHandleMultiSelect(note: note)
                    }
                }
            }
            .frame(minWidth: 250, idealWidth: 300, maxWidth: 300)
            .navigationTitle("Echoed Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: addNewNote) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button(action: confirmBulkDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                    .disabled(selectedForBulkDelete.isEmpty) // Enable only when notes are selected
                }
            }
        } detail: {
            if let selectedNote = selectedNote {
                NoteDetailView(note: selectedNote)
            } else {
                Text("Select or add a note to begin.")
                    .foregroundColor(.secondary)
                    .font(.headline)
            }
        }
        .alert("Delete Confirmation", isPresented: $isShowingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteNotes(selectedForBulkDelete)
            }
        } message: {
            Text("Are you sure you want to delete \(selectedForBulkDelete.count) notes?")
        }
    }
    
    /// Add a new note and select it
    private func addNewNote() {
        let newNote = TranscribedNote(
            title: "New Note",
            timestamp: Date()
        )
        modelContext.insert(newNote)
        
        do {
            try modelContext.save()
            selectedNote = newNote // Select the new note for editing
        } catch {
            print("Failed to save new note: \(error)")
        }
    }
    
    /// Handle single-click to select a single note
    private func handleSingleClick(note: TranscribedNote) {
        selectedNote = note // Mark the note as selected for editing
        selectedForBulkDelete = [note] // Replace any existing bulk selection
    }
    
    /// Handle double-click to open note in detail view
    private func openNoteInDetail(note: TranscribedNote) {
        selectedNote = note
    }
    
    /// Handle multi-selection (Shift or Cmd)
    private func handleMultiSelect(note: TranscribedNote, event: EventModifiers) {
        if event.contains(.shift) {
            selectRange(to: note)
        } else if event.contains(.command) {
            toggleBulkSelect(note: note)
        }
    }
    
    /// Select a range of notes using Shift-click
    private func selectRange(to note: TranscribedNote) {
        guard let lastSelected = lastSelectedNote else {
            selectedForBulkDelete.insert(note)
            lastSelectedNote = note
            return
        }

        // Find indexes of the last selected note and the newly clicked note
        if let startIndex = notes.firstIndex(of: lastSelected),
           let endIndex = notes.firstIndex(of: note) {
            let range = startIndex < endIndex
                ? notes[startIndex...endIndex]
                : notes[endIndex...startIndex]

            selectedForBulkDelete.formUnion(range) // Add all notes in the range to the bulk selection
            lastSelectedNote = note
        }
    }
    
    /// Toggle individual note selection (Cmd-click)
    private func toggleBulkSelect(note: TranscribedNote) {
        withAnimation {
            if selectedForBulkDelete.contains(note) {
                selectedForBulkDelete.remove(note)
            } else {
                selectedForBulkDelete.insert(note)
            }
        }
    }
    
    /// Confirm deletion of multiple selected notes
    private func confirmBulkDelete() {
        isShowingDeleteConfirmation = true
    }
    
    /// Delete one or more notes and reset selection
    private func deleteNotes(_ notesToDelete: Set<TranscribedNote>) {
        withAnimation {
            // Delete all selected notes
            notesToDelete.forEach { note in
                modelContext.delete(note)
            }

            do {
                try modelContext.save()
                // Clear all selections
                selectedNote = nil
                selectedForBulkDelete.removeAll()
            } catch {
                print("Failed to delete notes: \(error)")
            }
        }
    }
    
    /// Detect keyboard modifiers and handle multi-selection
    private func detectModifiersAndHandleMultiSelect(note: TranscribedNote) {
        // Detect the current modifiers (Shift, Cmd, etc.)
        guard let modifiers = NSApplication.shared.currentEvent?.modifierFlags else {
            handleSingleClick(note: note) // Default to single-click behavior
            return
        }

        if modifiers.contains(.shift) {
            selectRange(to: note) // Handle Shift-click for range selection
        } else if modifiers.contains(.command) {
            toggleBulkSelect(note: note) // Handle Cmd-click for individual toggle
        } else {
            handleSingleClick(note: note) // Default single-click
        }
    }
    
    
    /// Determine the background color for the note
    private func backgroundColor(for note: TranscribedNote) -> Color {
        if selectedForBulkDelete.contains(note) {
            return Color.blue.opacity(0.2) // All selected notes
        } else {
            return Color.clear // Default
        }
    }
}
