//
//  NoteDetailView.swift
//  echoed
//
//  Created by Guilherme Mota on 16/11/2024.
//

import SwiftUI
import Foundation
import SwiftData

struct NoteDetailView: View {
    @ObservedObject var viewModel: NoteDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Enter title...", text: $viewModel.note.title)
                .font(.title)
                .textFieldStyle(.plain)
                .onChange(of: viewModel.note.title) { oldValue, newValue in
                    viewModel.saveChanges() 
                }
            
            TextEditor(text: Binding(
                get: { viewModel.note.content ?? "" }, 
                set: { viewModel.note.content = $0 }
            ))
            .padding()
            .background(Color(NSColor.textBackgroundColor))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .frame(maxHeight: .infinity)
            
            Button(action: viewModel.captureLast30Seconds) {
                Label("Clip", systemImage: "scissors")
                    .frame(maxWidth: 80, maxHeight: 30) 
            }
            .customButton(
                foregroundColor: .white,
                backgroundColor: .blue,
                pressedColor: .orange.opacity(0.6)
            )
            .help("Clip Last 30 Seconds")
            .padding(.bottom)
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
            modelContext: try! ModelContainer(for: TranscribedNote.self).mainContext,
            transcriptionService: MockTranscriptionService()
        )
        
        return NoteDetailView(viewModel: mockViewModel)
    }
}
