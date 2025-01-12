//
//  echoedApp.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData
import Combine
import RevenueCat


@main
struct EchoedNotesApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: TranscribedNote.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        setupThirdPartyTools()
    }
    
    var body: some Scene {
        WindowGroup {
            EchoListView(viewModel: EchoListViewModel(modelContext: container.mainContext))
                .modelContainer(container) // Inject ModelContext
        }
    }
    
    private func setupThirdPartyTools() {
        let apiKey = getAPIKeyFromSecretPlace()
        Purchases.logLevel = .debug // Enables detailed logs for debugging
        Purchases.configure(withAPIKey: apiKey)
    }
    
    private func getAPIKeyFromSecretPlace() -> String {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = dictionary["API_KEY"] as? String {
            return apiKey
        } else {
            print("Error: Could not load API key.")
            return ""
        }
    }
}
