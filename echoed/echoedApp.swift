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
            // Initialize ModelContainer with your model types
            container = try ModelContainer(for: TranscribedNote.self)
            
            // Optionally, configure in-memory storage for testing
            // container = try ModelContainer(for: TranscribedNote.self, inMemory: true)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            EchoListView()
                .modelContainer(container) // Injects ModelContext into the environment
        }
    }
}
