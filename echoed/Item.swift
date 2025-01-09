//
//  Item.swift
//  echoed
//
//  Created by Guilherme  Mota on 09/01/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
