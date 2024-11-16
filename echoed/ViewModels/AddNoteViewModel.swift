//
//  AddNoteViewModel.swift
//  echoed
//
//  Created by Guilherme Mota on 16/11/2024.
//

import Foundation
import SwiftData
import Combine

class AddNoteViewModel: ObservableObject {
    // Published properties to bind with the view
    @Published var title: String = ""
    @Published var content: String = ""
    
    // Reference to the ModelContext
    var modelContext: ModelContext
    
    // Combine cancellables (if needed for future expansions)
    private var cancellables = Set<AnyCancellable>()
    
    // Initialize with ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // Function to add a new note
    func addNote() throws {
        // Trim whitespaces and validate inputs
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            throw ValidationError.emptyTitle
        }
        
        // Create a new TranscribedNote instance
        let newNote = TranscribedNote(title: trimmedTitle, content: trimmedContent)
        
        // Insert into the ModelContext
        modelContext.insert(newNote)
        
        // Save the context
        try modelContext.save()
    }
    
    // Custom Validation Errors
    enum ValidationError: LocalizedError {
        case emptyTitle
        
        var errorDescription: String? {
            switch self {
            case .emptyTitle:
                return "The title cannot be empty."
            }
        }
    }
}
