//
//  FloatingNoteView.swift
//  echoed
//
//  Created by Guilherme Mota on 14/09/2024.
//

import SwiftUI


struct FloatingNoteView: View {
    @State private var isRecording = false
    @State private var transcribedText = ""
    
    var body: some View {
        VStack {
            Text("Echoed Note")
                .font(.headline)
            
            TextEditor(text: $transcribedText)
                .frame(height: 100)
                .border(Color.gray, width: 1)
            
            HStack {
                Button(action: toggleRecording) {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .foregroundColor(isRecording ? .red : .blue)
                }
                
                Button("Save") {
                    // TODO: Implement save functionality
                }
            }
        }
        .padding()
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
    
    private func toggleRecording() {
        isRecording.toggle()
        // TODO: Implement actual recording logic
    }
}


#Preview {
    FloatingNoteView()
}
