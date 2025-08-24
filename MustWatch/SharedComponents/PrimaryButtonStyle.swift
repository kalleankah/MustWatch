//
//  PrimaryButtonStyle.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-23.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.headline)
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color.black.opacity(0.1) : .clear)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.interactiveSpring, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

#Preview {
    Button("Test Button") {

    }
    .buttonStyle(PrimaryButtonStyle())
}
