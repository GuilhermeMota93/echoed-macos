//
//  View+Extensions.swift
//  echoed
//
//  Created by Guilherme Mota on 17/11/2024.
//

import Foundation
import SwiftUI


extension View {
    func customButton(
        foregroundColor: Color = .white,
        backgroundColor: Color = .blue,
        pressedColor: Color = .gray
    ) -> some View {
        self.buttonStyle(
            CustomButtonStyle(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                pressedColor: pressedColor
            )
        )
    }
}
