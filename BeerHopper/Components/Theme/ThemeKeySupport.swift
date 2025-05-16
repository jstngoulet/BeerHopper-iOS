//
//  ThemeKeySupport.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


import SwiftUI

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue = Theme()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}
