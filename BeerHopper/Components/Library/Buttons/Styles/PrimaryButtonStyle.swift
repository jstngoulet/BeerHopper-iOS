//
//  PrimaryButtonStyle.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import SwiftUI
import DesignSystem

struct PrimaryButtonStyle: ButtonStyle {
    
    let isDisabled: Bool
 
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(
                isDisabled
                ? Theme.Colors.textPrimary
                : Theme.Colors.paper
            )
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                !isDisabled
                    ? configuration.isPressed
                        ? Theme.Colors.primary.opacity(0.7)
                        : Theme.Colors.primary
                    : Theme.Colors.background
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
}

#Preview("PrimaryButtonStyle") {
    Button("Primary") {}
        .buttonStyle(PrimaryButtonStyle(isDisabled: false))
        .padding()
}

#Preview("DisabledButtonStyle") {
    Button("Disabled") {}
        .buttonStyle(PrimaryButtonStyle(isDisabled: true))
        .padding()
}

#Preview("Both Button Styles") {
    VStack(spacing: 15) {
        Button("Primary") {}
            .buttonStyle(PrimaryButtonStyle(isDisabled: false))
            .padding()
        Button("Disabled") {}
            .buttonStyle(PrimaryButtonStyle(isDisabled: true))
            .padding()
    }
}
