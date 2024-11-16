//
//  NoteDetailView.swift
//  echoed
//
//  Created by Guilherme Mota on 16/11/2024.
//

import SwiftUI
import Foundation

extension Binding {
    /// Helper to replace nil values with a default value
    init(_ source: Binding<Value?>, replacingNilWith defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}

struct NoteDetailView: View {
    @Bindable var note: TranscribedNote // Automatically updates the SwiftData model

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Title", text: $note.title)
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 10)

            TextEditor(text: Binding($note.content, replacingNilWith: ""))
                .padding()
                .background(Color(.secondaryLabelColor))
                .cornerRadius(8)
                .frame(minHeight: 300)

            Spacer()

            Text(note.timestamp, format: .dateTime)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
