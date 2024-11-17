//
//  CustomButtonStyle.swift
//  echoed
//
//  Created by Guilherme Mota on 17/11/2024.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var foregroundColor: Color
    var backgroundColor: Color
    var pressedColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(10)
            .foregroundColor(foregroundColor)
            .background(configuration.isPressed ? pressedColor : backgroundColor)
            .cornerRadius(6)
    }
}
