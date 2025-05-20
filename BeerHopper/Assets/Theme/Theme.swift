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
        // ✅ Existing Fonts (Preserved)
        static let heading = Font.custom("Roboto-Bold", size: 28)
        static let subheading = Font.custom("Roboto-Medium", size: 22)
        static let body = Font.custom("Roboto-Regular", size: 16)
        static let caption = Font.custom("Roboto-Regular", size: 12)
        static let captionBold = Font.custom("Roboto-Bold", size: 12)
        
        // ✅ Material UI Type Scale (Expanded)
        
        // Display (H1-H2)
        static let displayLarge     = Font.custom("Roboto-Light", size: 57)
        static let displayMedium    = Font.custom("Roboto-Light", size: 45)
        static let displaySmall     = Font.custom("Roboto-Regular", size: 36)
        
        // Headline
        static let headlineLarge    = Font.custom("Roboto-Regular", size: 32)
        static let headlineMedium   = Font.custom("Roboto-Regular", size: 28)
        static let headlineSmall    = Font.custom("Roboto-Medium", size: 24)
        
        // Title
        static let titleLarge       = Font.custom("Roboto-Regular", size: 22)
        static let titleMedium      = Font.custom("Roboto-Medium", size: 16)
        static let titleSmall       = Font.custom("Roboto-Medium", size: 14)
        
        // Label (Buttons, Chips, etc.)
        static let labelLarge       = Font.custom("Roboto-Medium", size: 14)
        static let labelMedium      = Font.custom("Roboto-Medium", size: 12)
        static let labelSmall       = Font.custom("Roboto-Medium", size: 11)
        
        // Body
        static let bodyLarge        = Font.custom("Roboto-Regular", size: 16)
        static let bodyMedium       = Font.custom("Roboto-Regular", size: 14)
        static let bodySmall        = Font.custom("Roboto-Regular", size: 12)
        
        // Optional italics (if you want to style secondary/descriptive content)
        static let bodySmallItalic  = Font.custom("Roboto-Italic", size: 12)
        static let captionItalic    = Font.custom("Roboto-Italic", size: 12)
    }
    
    let colors = Colors()
    let fonts = Fonts()
}
