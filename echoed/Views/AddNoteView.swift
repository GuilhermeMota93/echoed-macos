//
//  AddNoteView.swift
//  echoed
//
//  Created by Guilherme Mota on 15/11/2024.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New Note")
                .font(.title)
                .bold()
                .padding(.bottom, 10)

            // Title Input
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)

            // Content Input
            TextEditor(text: $content)
                .padding(4)
                .background(Color(NSColor.windowBackgroundColor))
                .cornerRadius(5)
                .frame(height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.bottom, 10)

            // Buttons
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction) // Cmd + .
                .padding()

                Button("Save") {
                    saveNote()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction) // Enter key
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty ||
                          content.trimmingCharacters(in: .whitespaces).isEmpty)
                .padding()
            }
        }
        .padding()
        .frame(width: 500, height: 400)
    }

    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        let trimmedContent = content.trimmingCharacters(in: .whitespaces)

        guard !trimmedTitle.isEmpty, !trimmedContent.isEmpty else {
            return
        }

        let newNote = TranscribedNote(title: trimmedTitle, content: trimmedContent, timestamp: Date())
        modelContext.insert(newNote)

        do {
            try modelContext.save()
        } catch {
            // Handle the error appropriately in a real app
            print("Failed to save note: \(error)")
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a mock ModelContext for previews
        let container = try! ModelContainer(for: TranscribedNote.self)
        let modelContext = ModelContext(container)
        AddNoteView()
            .environment(\.modelContext, modelContext)
    }
}
