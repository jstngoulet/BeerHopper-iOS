//
//  Theme.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import SwiftUI

struct Theme {
    
    struct Colors {
        static let primary = Color(hex: "#B5836D")       // Warm golden tone
        static let secondary = Color(hex: "#5A331E")     // Rustic brown
        static let background = Color(hex: "#F5EEDC")    // Light wood background
        static let paper = Color.white                  // Equivalent to MUI's paper
        static let textPrimary = Color(hex: "#3B2F2F")   // Dark brown
        static let textSecondary = Color(hex: "#6B4226") // Muted brown
        static let success = Color(hex: "#8CB369")       // Hops green
        static let warning = Color(hex: "#F4A261")       // Amber
        static let info = Color(hex: "#4682B4")          // Steel blue
        static let error = Color(hex: "#B00020")         // Standard material red
    }
    
    struct Fonts {
        static let heading = Font.custom("Roboto-Bold", size: 28)
        static let subheading = Font.custom("Roboto-Medium", size: 22)
        static let body = Font.custom("Roboto-Regular", size: 16)
        static let caption = Font.custom("Roboto-Regular", size: 12)
    }
    
    let colors = Colors()
    let fonts = Fonts()
}
