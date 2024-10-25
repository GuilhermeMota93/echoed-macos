//
//  echoedApp.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData

//@main
//struct echoedApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            TranscribedNote.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//    
//    init() {
//        setupFloatingPanel()
//    }
//
//    var body: some Scene {
//        Settings {
//            EmptyView()
//        }
//    }
//
//    private func setupFloatingPanel() {
//        let transcriptionService = MockTranscriptionService() //TranscriptionService()
//        let viewModel = FloatingNoteViewModel(transcriptionService: transcriptionService)
//
//        let panel = NSPanel(
//            contentViewController: NSHostingController(rootView: FloatingNoteView(viewModel: viewModel))
////            contentViewController: NSHostingController(rootView: ContentView())
//        )
//
//        panel.styleMask = [.titled, .closable, .resizable, .miniaturizable]
//        panel.title = "New Echoed"
//        panel.appearance = NSAppearance(named: .aqua)
//        panel.isOpaque = false
//        panel.backgroundColor = .windowBackgroundColor
//        panel.isFloatingPanel = true
//        panel.hidesOnDeactivate = false
//        panel.level = .floating
//        panel.isMovableByWindowBackground = true
//        panel.makeKeyAndOrderFront(nil)
//    }
//}

@main
struct echoedApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TranscribedNote.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        setupFloatingPanel()
    }

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }

    @MainActor
    private func setupFloatingPanel() {
        // Directly access the mainContext as it's already on the main actor
        let modelContext = sharedModelContainer.mainContext
        
        // Pass the modelContext to the EchoListViewModel
        let viewModel = EchoListViewModel(modelContext: modelContext)
        
        // Update UI on the main thread (this is still necessary)
        DispatchQueue.main.async {
            let panel = NSPanel(
                contentViewController: NSHostingController(rootView: EchoListView(viewModel: viewModel))
            )
            
            panel.styleMask = [.titled, .closable, .resizable, .miniaturizable]
            panel.title = "New Echoed"
            panel.appearance = NSAppearance(named: .aqua)
            panel.isOpaque = false
            panel.backgroundColor = .windowBackgroundColor
            panel.isFloatingPanel = true
            panel.hidesOnDeactivate = false
            panel.level = .floating
            panel.isMovableByWindowBackground = true
            panel.makeKeyAndOrderFront(nil)
        }
    }


}
