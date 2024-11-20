//
//  ContentView.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData
import AVFoundation

import SwiftUI
import SwiftData
import AVFoundation

struct EchoListView: View {
    @ObservedObject var viewModel: EchoListViewModel
    @State private var isMicrophoneAccessGranted: Bool = true
    @State private var showPermissionAlert: Bool = false

    var body: some View {
        NavigationSplitView {
            ScrollViewReader { proxy in
                List(selection: $viewModel.selectedNote) {
                    ForEach(viewModel.notes) { note in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(note.title)
                                    .font(.headline)
                                Text(note.timestamp, format: Date.FormatStyle()
                                    .day().month(.abbreviated).year()
                                    .hour().minute().second()) // Full timestamp format
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                        .background(noteBackgroundColor(for: note))
                        .cornerRadius(8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            handleTapGesture(for: note)
                        }
                        .id(note.id) // Assign a unique ID to each note for scrolling
                    }
                }
                .frame(minWidth: 250, idealWidth: 300, maxWidth: 300)
                .navigationTitle("Echoed Notes")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            viewModel.addNewNote()
                            scrollToNewNote(proxy: proxy) // Scroll to the newly added note
                        }) {
                            Label("Add Note", systemImage: "plus")
                        }
                        .disabled(!isMicrophoneAccessGranted)
                    }
                    ToolbarItem(placement: .destructiveAction) {
                        Button(action: viewModel.confirmBulkDelete) {
                            Label("Delete", systemImage: "trash")
                        }
                        .disabled(viewModel.selectedForBulkDelete.isEmpty || !isMicrophoneAccessGranted)
                    }

                    ToolbarItem(placement: .primaryAction) {
                        if !isMicrophoneAccessGranted {
                            Button(action: {
                                showPermissionAlert = true
                            }) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .help("Microphone permissions are off")
                        }
                    }
                }
            }
        } detail: {
            if let selectedNote = viewModel.selectedNote {
                NoteDetailView(
                    viewModel: NoteDetailViewModel(
                        note: selectedNote,
                        modelContext: viewModel.modelContext,
                        transcriptionService: MockTranscriptionService()
                    )
                )
                .disabled(!isMicrophoneAccessGranted)
            } else {
                Text("Select or create a new note to begin.")
                    .foregroundColor(.secondary)
                    .font(.headline)
            }
        }
        .alert("Delete Confirmation", isPresented: $viewModel.isShowingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteNotes(viewModel.selectedForBulkDelete)
            }
        } message: {
            Text("Are you sure you want to delete \(viewModel.selectedForBulkDelete.count) notes?")
        }
        .onAppear {
            viewModel.fetchNotes()
            checkMicrophonePermissions()
        }
        .alert("Permission Issue", isPresented: $showPermissionAlert) {
            Button("OK") {}
        } message: {
            Text("Microphone access is required for transcription. Go to System Settings -> Privacy -> Microphone to enable it.")
        }
    }

    /// Scrolls to the newly added note
    private func scrollToNewNote(proxy: ScrollViewProxy) {
        if let newNote = viewModel.selectedNote {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Small delay ensures the note is added
                proxy.scrollTo(newNote.id, anchor: .center)
            }
        }
    }

    /// Handle tap gesture, detecting modifiers for multi-select or range select
    private func handleTapGesture(for note: TranscribedNote) {
        let modifiers = NSApp.currentEvent?.modifierFlags ?? []
        if modifiers.contains(.shift) {
            // Range select (Shift-click)
            viewModel.selectRange(from: viewModel.lastSelectedNote, to: note)
        } else if modifiers.contains(.command) {
            // Toggle selection (Cmd-click)
            viewModel.toggleSelection(note: note)
        } else {
            // Single selection
            viewModel.selectSingle(note: note)
        }
    }

    /// Determine the background color for a note
    private func noteBackgroundColor(for note: TranscribedNote) -> Color {
        if viewModel.selectedForBulkDelete.contains(note) {
            return Color.blue.opacity(0.2)
        } else {
            return Color.clear
        }
    }

    /// Checks the current microphone permission status
    private func checkMicrophonePermissions() {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        isMicrophoneAccessGranted = (status == .authorized)
    }
}

struct EchoListView_Previews: PreviewProvider {
    static var previews: some View {
        // In-memory ModelContainer for testing
        let container = try! ModelContainer(for: TranscribedNote.self)
        
        // Mock EchoListViewModel using the in-memory context
        let mockViewModel = EchoListViewModel(modelContext: container.mainContext)
        
        // Mock data for preview
        let previewNotes = [
            TranscribedNote(title: "First Note", timestamp: Date().addingTimeInterval(-3600)),
            TranscribedNote(title: "Second Note", timestamp: Date())
        ]
        previewNotes.forEach { container.mainContext.insert($0) }
        
        return EchoListView(viewModel: mockViewModel)
            .modelContainer(container) // Inject the in-memory container
    }
}
