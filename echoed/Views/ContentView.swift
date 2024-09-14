//
//  ContentView.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [TranscribedNote]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(notes) { note in
                    NavigationLink {
                        TranscribedNoteDetailView(note: note)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(note.text.prefix(50) + (note.text.count > 50 ? "..." : ""))
                                .lineLimit(1)
                        }
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addNote) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a note")
        }
    }

    private func addNote() {
        withAnimation {
            let newNote = TranscribedNote(timestamp: Date(), text: "New note", duration: 0, isUserEdited: false)
            modelContext.insert(newNote)
        }
    }

    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(notes[index])
            }
        }
    }
}

#Preview {
    ContentView()
           .modelContainer(for: TranscribedNote.self, inMemory: true)
}
