//
//  NoteDetailView.swift
//  echoed
//
//  Created by Guilherme Mota on 16/11/2024.
//

import SwiftUI
import Foundation

import SwiftUI
import Foundation

struct NoteDetailView: View {
    @ObservedObject var viewModel: NoteDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: viewModel.captureLast30Seconds) {
                    Label("Get Last 30 Seconds", systemImage: "scissors")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.bottom)

            TextEditor(text: $viewModel.noteContent)
                .padding()
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )

            Spacer()
        }
        .padding()
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockNote = TranscribedNote(
            title: "Sample Note",
            content: "This is a test note.",
            timestamp: Date()
        )

        let mockViewModel = NoteDetailViewModel(
            note: mockNote,
            transcriptionService: MockTranscriptionService()
        )

        return NoteDetailView(viewModel: mockViewModel)
    }
}
