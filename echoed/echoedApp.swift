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
struct echoedApp: App {
    // Shared ModelContainer across the app
    let sharedModelContainer: ModelContainer = {
        do {
            let modelConfiguration = ModelConfiguration(for: TranscribedNote.self, isStoredInMemoryOnly: false)
            return try ModelContainer(for: TranscribedNote.self, configurations: modelConfiguration)
        } catch {
            print("Failed to create ModelContainer: \(error.localizedDescription)")
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            EchoListView()
                .modelContainer(sharedModelContainer) // Inject the model container into the environment
        }
    }
}
