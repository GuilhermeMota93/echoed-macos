//
//  AddNoteView.swift
//  echoed
//
//  Created by Guilherme Mota on 15/11/2024.
//

import Foundation
import SwiftUI
import Combine

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: EchoListViewModel
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New Note")
                .font(.title)
                .padding(.bottom, 10)
            
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $content)
                .border(Color.gray, width: 1)
                .frame(height: 200)
            
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Save") {
                    saveNote()
                }
                .disabled(title.isEmpty || content.isEmpty)
            }
        }
        .padding()
        .frame(width: 400)
    }
    
    private func saveNote() {
        viewModel.addNote(title: title, content: content)
        dismiss()
    }
}
