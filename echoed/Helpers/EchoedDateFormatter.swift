//
//  EchoedDateFormatter.swift
//  echoed
//
//  Created by Guilherme Mota on 15/11/2024.
//

import Foundation

protocol EchoDateFormattingServiceable {
    func format(date: Date) -> String
}

class EchoDateFormattingService: EchoDateFormattingServiceable {
    private let dateFormatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }

    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}


class MockEchoDateFormattingServicea: EchoDateFormattingServiceable {
    func format(date: Date) -> String {
        return "Mocked Date"
    }
}
