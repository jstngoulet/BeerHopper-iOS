//
//  ButtonConfig.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/17/25.
//
import SwiftUI

struct ButtonConfig: Identifiable, Equatable {
    let id: String
    let title: String
    let icon: Image?
    let action: @MainActor () -> Void
    
    static func == (lhs: ButtonConfig, rhs: ButtonConfig) -> Bool
    { lhs.id == rhs.id }
    
    init(
        id: String,
        title: String,
        icon: Image? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
    }
}
