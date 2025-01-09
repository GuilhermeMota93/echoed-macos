//
//  echoedApp.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData
import Combine

@main
struct EchoedNotesApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: TranscribedNote.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            EchoListView(viewModel: EchoListViewModel(modelContext: container.mainContext))
                .modelContainer(container) // Inject ModelContext
        }
    }
}