//
//  echoedApp.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import SwiftUI
import SwiftData
import Combine
import AVFoundation

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
                .modelContainer(container)
                .onAppear {
                    requestMicrophoneAccess { granted in
                        if !granted {
                            print("Microphone access is required for transcription.")
                        }
                    }
                }
        }
    }
    
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Microphone access granted")
                } else {
                    print("Microphone access denied")
                }
                completion(granted)
            }
        }
    }
}
