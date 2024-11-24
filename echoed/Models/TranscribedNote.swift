//
//  TranscribedNote.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import Foundation
import SwiftData

/**
 NOTE: To add new fields in the future, simply introduce new properties with the @Attribute macro. 
 SwiftData will handle migrations gracefully.
 
 Example: Adding a category Field:
 @Attribute var category: String
 */

@Model
final class TranscribedNote: Identifiable, ObservableObject {
    @Attribute var title: String
    @Attribute var content: String?
    @Attribute var timestamp: Date

    init(title: String, content: String? = nil, timestamp: Date = Date()) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }
}
