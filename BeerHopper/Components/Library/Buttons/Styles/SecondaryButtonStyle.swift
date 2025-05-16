//
//  SecondaryButtonStyle.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Theme.Colors.primary)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                configuration.isPressed
                    ? Theme.Colors.paper.opacity(0.7)
                    : Theme.Colors.paper
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.Colors.primary, lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
}
