//
//  ToggleButton.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/18/25.
//
import SwiftUI

struct ToggleButton: View {
    
    let isSelected: Bool
    let action: @MainActor () -> Void
    let image: Image
    
    var body: some View {
        Button(action: action) {
            image
                .font(.body.weight(.medium))
                .foregroundStyle(
                    isSelected
                    ? Theme.Colors.warning
                    : Theme.Colors.textPrimary
                )
                .padding(8)
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Toggle \(isSelected ? "off" : "on")"))
        }
    }
    
}
