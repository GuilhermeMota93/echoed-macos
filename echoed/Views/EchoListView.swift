//
//  EchoListView.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData
import RevenueCat

struct EchoListView: View {
    @ObservedObject var viewModel: EchoListViewModel

    // RevenueCat State
    @State private var isPaywallVisible: Bool = false
    @State private var offerings: Offerings?
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // Main UI
            NavigationSplitView {
                List(selection: $viewModel.selectedNote) {
                    ForEach(viewModel.notes) { note in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(note.title)
                                    .font(.headline)
                                Text(note.timestamp, format: .dateTime)
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
                            viewModel.selectSingle(note: note)
                        }
                    }
                }
                .frame(minWidth: 250, idealWidth: 300, maxWidth: 300)
                .navigationTitle("Echoed Notes")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: viewModel.addNewNote) {
                            Label("Add Note", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .destructiveAction) {
                        Button(action: viewModel.confirmBulkDelete) {
                            Label("Delete", systemImage: "trash")
                        }
                        .disabled(viewModel.selectedForBulkDelete.isEmpty)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            fetchOfferings()
                            isPaywallVisible = true
                        }) {
                            Label("Show Paywall", systemImage: "creditcard")
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
            }

            // Paywall UI Overlay
            if isPaywallVisible {
                paywallOverlay
            }
        }
    }

    private var paywallOverlay: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 16) {
                if let offerings = offerings {
                    let packages = offerings.current?.availablePackages ?? []
                    List(packages, id: \ .identifier) { package in
                        Button(action: {
                            purchase(package: package)
                        }) {
                            Text("Buy \(package.storeProduct.localizedTitle) for \(package.storeProduct.localizedPriceString ?? "")")
                        }
                    }
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    Text("Loading paywall...")
                }
                Button("Close") {
                    isPaywallVisible = false
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
        }
    }

    private func fetchOfferings() {
        Purchases.shared.getOfferings { offerings, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.offerings = offerings
            }
        }
    }
   


    private func purchase(package: Package) {
        Purchases.shared.purchase(package: package) { _, _, error, userCancelled in
            if let error = error {
                print("Purchase failed: \(error.localizedDescription)")
            } else if userCancelled {
                print("Purchase cancelled")
            } else {
                print("Purchase successful!")
                isPaywallVisible = false
            }
        }
    }

    private func noteBackgroundColor(for note: TranscribedNote) -> Color {
        if viewModel.selectedForBulkDelete.contains(note) {
            return Color.blue.opacity(0.2)
        } else {
            return Color.clear
        }
    }
}

struct EchoListView_Previews: PreviewProvider {
    static var previews: some View {
        let container = try! ModelContainer(for: TranscribedNote.self)
        let mockViewModel = EchoListViewModel(modelContext: container.mainContext)
        let previewNotes = [
            TranscribedNote(title: "First Note", timestamp: Date().addingTimeInterval(-3600)),
            TranscribedNote(title: "Second Note", timestamp: Date())
        ]
        previewNotes.forEach { container.mainContext.insert($0) }
        return EchoListView(viewModel: mockViewModel)
            .modelContainer(container)
    }
}
