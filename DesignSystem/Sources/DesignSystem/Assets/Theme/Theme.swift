//
//  Theme.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import SwiftUI

public struct Theme {
    
    public struct Colors {
        public static let primary = Color(hex: "#B5836D")       // Warm golden tone
        public static let secondary = Color(hex: "#5A331E")     // Rustic brown
        public static let background = Color(hex: "#F5EEDC")    // Light wood background
        public static let paper = Color.white                  // Equivalent to MUI's paper
        public static let textPrimary = Color(hex: "#3B2F2F")   // Dark brown
        public static let textSecondary = Color(hex: "#6B4226") // Muted brown
        public static let success = Color(hex: "#8CB369")       // Hops green
        public static let warning = Color(hex: "#F4A261")       // Amber
        public static let info = Color(hex: "#4682B4")          // Steel blue
        public static let error = Color(hex: "#B00020")         // Standard material red
    }
    
    public struct Fonts {
        // ✅ Existing Fonts (Preserved)
        public static let heading = Font.custom("Roboto-Bold", size: 28)
        public static let subheading = Font.custom("Roboto-Medium", size: 22)
        public static let body = Font.custom("Roboto-Regular", size: 16)
        public static let caption = Font.custom("Roboto-Regular", size: 12)
        public static let captionBold = Font.custom("Roboto-Bold", size: 12)
        
        // ✅ Material UI Type Scale (Expanded)
        
        // Display (H1-H2)
        public static let displayLarge     = Font.custom("Roboto-Light", size: 57)
        public static let displayMedium    = Font.custom("Roboto-Light", size: 45)
        public static let displaySmall     = Font.custom("Roboto-Regular", size: 36)
        
        // Headline
        public static let headlineLarge    = Font.custom("Roboto-Regular", size: 32)
        public static let headlineMedium   = Font.custom("Roboto-Regular", size: 28)
        public static let headlineSmall    = Font.custom("Roboto-Medium", size: 24)
        
        // Title
        public static let titleLarge       = Font.custom("Roboto-Regular", size: 22)
        public static let titleMedium      = Font.custom("Roboto-Medium", size: 16)
        public static let titleSmall       = Font.custom("Roboto-Medium", size: 14)
        
        // Label (Buttons, Chips, etc.)
        public static let labelLarge       = Font.custom("Roboto-Medium", size: 14)
        public static let labelMedium      = Font.custom("Roboto-Medium", size: 12)
        public static let labelSmall       = Font.custom("Roboto-Medium", size: 11)
        
        // Body
        public static let bodyLarge        = Font.custom("Roboto-Regular", size: 16)
        public static let bodyMedium       = Font.custom("Roboto-Regular", size: 14)
        public static let bodySmall        = Font.custom("Roboto-Regular", size: 12)
        
        // Optional italics (if you want to style secondary/descriptive content)
        public static let bodySmallItalic  = Font.custom("Roboto-Italic", size: 12)
        public static let captionItalic    = Font.custom("Roboto-Italic", size: 12)
    }
    
    public let colors = Colors()
    public let fonts = Fonts()
}
