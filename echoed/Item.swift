//
//  Item.swift
//  echoed
//
//  Created by Guilherme Mota on 13/09/2024.
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
