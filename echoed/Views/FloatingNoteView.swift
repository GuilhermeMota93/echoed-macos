//
//  FloatingNoteView.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI

struct FloatingNoteView: View {
    @StateObject private var viewModel: FloatingNoteViewModel
    @FocusState private var focusedTranscriptionID: UUID?
    @State private var showEndSessionDialog = false
    
    init(viewModel: FloatingNoteViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text(viewModel.autoSaveMessage)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 10)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.transcriptions) { transcription in
                            VStack(alignment: .leading) {
                                Text(transcription.timestamp)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                TextEditor(text: Binding(
                                    get: {
                                        transcription.editableText
                                    },
                                    set: { newValue in
                                        if let index = viewModel.transcriptions.firstIndex(where: { $0.id == transcription.id }) {
                                            viewModel.transcriptions[index].editableText = newValue
                                        }
                                    }
                                ))
                                .focused(
                                    $focusedTranscriptionID,
                                    equals: transcription.id
                                )
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(height: 80)
                                .onChange(of: focusedTranscriptionID, { oldValue, newValue in
                                    if newValue == transcription.id {
                                        withAnimation {
                                            proxy.scrollTo(transcription.id, anchor: .center)
                                        }
                                    }
                                })
                            }
                            .padding(.vertical, 5)
                            .background(Color.clear)
                            
                            Divider()
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                }
            }
            .frame(minHeight: 200)
            .background(Color.clear)
            
            // Record and End Session buttons
            HStack(spacing: 0) {
                // Record button
                Button(action: {
                    viewModel.toggleRecording()
                }, label: {
                    VStack {
                        Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(viewModel.isRecording ? .red : .blue)
                    }
                    .frame(width: 35, height: 35)
                })
                
                Spacer()
                
                // End Session button
                Button(action: {
                    showEndSessionDialog = true
                }, label: {
                    HStack {
                        Text("End Session")
                            .foregroundColor(.white)
                            
                    }
                    .frame(width: 130, height: 40)
                    .background(Color.red.opacity(0.8))
                })
                .confirmationDialog(
                    "Are you sure you want to end this session?",
                    isPresented: $showEndSessionDialog
                ) {
                    Button("Yes", role: .destructive) {
                        endSession()
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }.padding(.bottom, 15)
        }
        .padding(.horizontal, 20)
        .frame(width: 400, height: 400)
        .background(Color.white)
    }
    
    private func endSession() {
        NSApplication.shared.terminate(self)
    }
}

//#Preview {
//    let viewModel = FloatingNoteViewModel(
//        transcriptionService: MockTranscriptionService()
//    )
//    return FloatingNoteView(viewModel: viewModel)
//}

