//
//  TextChip.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//
import SwiftUI

struct TextChip: View {
    let buttonConfig: ButtonConfig
    
    var body: some View {
        Button(action: buttonConfig.action) {
            HStack(spacing: 6) {
                if let icon = buttonConfig.icon {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                }
                Text(buttonConfig.title)
                    .lineLimit(1)
                    .font(Theme.Fonts.body)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Theme.Colors.background)
            .foregroundStyle(Theme.Colors.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    TextChip(
        buttonConfig: ButtonConfig(
            id: "id",
            title: "Text",
            icon: Image(systemName: "lock"),
            action: {
                print("Hello World")
            }
        )
    )
}
