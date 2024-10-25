//
//  ContentView.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData

struct EchoListView: View {
    @ObservedObject var viewModel: EchoListViewModel

    var body: some View {
        NavigationSplitView {
            // Left Panel: List of notes
            List(selection: $viewModel.selectedNote) {
                ForEach(viewModel.notes) { note in
                    NavigationLink(value: note) {
                        VStack(alignment: .leading) {
                            Text(note.text.prefix(50) + (note.text.count > 50 ? "..." : ""))
                                .lineLimit(1)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteNotes)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        viewModel.addNote()  // Create and select a new note
                    }) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if let selectedNote = viewModel.selectedNote {
                // Show the selected note in FloatingNoteView on the right-hand side
                FloatingNoteView(viewModel: FloatingNoteViewModel(
                    transcriptionService: TranscriptionService(),
                    modelContext: viewModel.modelContext
                ))
            } else {
                // Placeholder for when no note is selected
                Text("Select or add a note")
            }
        }
        .frame(minWidth: 650, minHeight: 400)
    }
}
