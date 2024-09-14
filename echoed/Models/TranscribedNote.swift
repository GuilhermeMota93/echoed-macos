//
//  TranscribedNote.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
//

import Foundation
import SwiftData

@Model
final class TranscribedNote {
    var timestamp: Date
    var text: String
    var duration: TimeInterval
    var isUserEdited: Bool

    init(
        timestamp: Date = Date(),
        text: String,
        duration: TimeInterval,
        isUserEdited: Bool = false
    ) {
        self.timestamp = timestamp
        self.text = text
        self.duration = duration
        self.isUserEdited = isUserEdited
    }
}
