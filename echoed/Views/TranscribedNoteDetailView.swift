//
//  TranscribedNoteDetailView.swift
//  echoed
//
//  Created by Guilherme Mota on 14/09/2024.
//

import SwiftUI

struct TranscribedNoteDetailView: View {
    let note: TranscribedNote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(note.text)
                .font(.body)
            Text("Duration: \(note.duration) seconds")
            Text("Timestamp: \(note.timestamp, format: .dateTime)")
            Text("User Edited: \(note.isUserEdited ? "Yes" : "No")")
        }
        .padding()
        .navigationTitle("Note Details")
    }
}

#Preview {
    let note = TranscribedNote(
        text: "Test",
        duration: Date().timeIntervalSince1970
    )
    return TranscribedNoteDetailView(note: note)
}
