//
//  ContentView.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData

struct EchoListView: View {
    @ObservedObject var viewModel: EchoListViewModel // Injected ViewModel

    var body: some View {
        NavigationSplitView {
            List(selection: $viewModel.selectedNote) {
                ForEach(viewModel.notes) { note in
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                    .background(viewModel.backgroundColor(for: note))
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        handleTapGesture(for: note)
                    }
                }
            }
            .frame(minWidth: 250, idealWidth: 300, maxWidth: 300)
            .navigationTitle("Echoed Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: viewModel.addNewNote) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button(action: viewModel.confirmBulkDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                    .disabled(viewModel.selectedForBulkDelete.isEmpty)
                }
            }
        } detail: {
            if let selectedNote = viewModel.selectedNote {
                NoteDetailView(note: selectedNote)
            } else {
                Text("Select or create a new note to begin.")
                    .foregroundColor(.secondary)
                    .font(.headline)
            }
        }
        .alert("Delete Confirmation", isPresented: $viewModel.isShowingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteNotes(viewModel.selectedForBulkDelete)
            }
        } message: {
            Text("Are you sure you want to delete \(viewModel.selectedForBulkDelete.count) notes?")
        }
        .onAppear {
            viewModel.fetchNotes() // Fetch notes when the view appears
        }
    }

    /// Handle tap gesture, detecting modifiers for multi-select
    private func handleTapGesture(for note: TranscribedNote) {
        let modifiers = NSApp.currentEvent?.modifierFlags ?? []
        if modifiers.contains(.shift) {
            viewModel.selectRange(from: viewModel.lastSelectedNote, to: note)
        } else if modifiers.contains(.command) {
            viewModel.toggleSelection(note: note)
        } else {
            viewModel.selectSingle(note: note)
        }
    }
}

struct EchoListView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an in-memory ModelContainer for testing
        let container = try! ModelContainer(for: TranscribedNote.self)

        // Create a mock EchoListViewModel using the in-memory context
        let mockViewModel = EchoListViewModel(modelContext: container.mainContext)

        // Insert mock data for preview
        let previewNotes = [
            TranscribedNote(title: "First Note", timestamp: Date().addingTimeInterval(-3600)),
            TranscribedNote(title: "Second Note", timestamp: Date())
        ]
        previewNotes.forEach { container.mainContext.insert($0) }

        return EchoListView(viewModel: mockViewModel)
            .modelContainer(container) // Inject the in-memory container
    }
}
