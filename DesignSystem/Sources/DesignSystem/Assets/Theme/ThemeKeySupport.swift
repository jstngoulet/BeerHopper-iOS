//
//  ThemeKeySupport.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


import SwiftUI

@MainActor
private struct AppThemeKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = Theme()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}
