import SwiftUI
import SwiftData

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

    private func setupFloatingPanel() {
        let panel = NSPanel(
            contentViewController: NSHostingController(rootView: FloatingNoteView())
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

    
    private func openSavedNotesWindow() {
        let newWindow = NSWindow(
            contentViewController: NSHostingController(rootView: ContentView())
        )
        newWindow.makeKeyAndOrderFront(nil)
    }
}
