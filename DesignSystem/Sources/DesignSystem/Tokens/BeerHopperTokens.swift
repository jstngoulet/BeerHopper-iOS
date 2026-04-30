import SwiftUI

public enum BHSpacing {
    public static let xSmall: CGFloat = 4
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 16
    public static let xLarge: CGFloat = 20
    public static let xxLarge: CGFloat = 24
    public static let xxxLarge: CGFloat = 32
}

public enum BHRadius {
    public static let compact: CGFloat = 8
    public static let group: CGFloat = 12
}

public enum BHColor {
    public static let background = Color(red: 0.97, green: 0.98, blue: 0.99)
    public static let groupedBackground = Color(red: 0.94, green: 0.96, blue: 0.98)
    public static let surface = Color.white
    public static let textPrimary = Color.primary
    public static let textSecondary = Color.secondary
    public static let border = Color.gray.opacity(0.35)
    public static let action = Color(red: 0.15, green: 0.39, blue: 0.92)
    public static let success = Color(red: 0.09, green: 0.64, blue: 0.29)
    public static let warning = Color(red: 0.96, green: 0.62, blue: 0.04)
    public static let info = Color(red: 0.02, green: 0.52, blue: 0.78)
}

public enum BHColumnSizeClass: Equatable {
    case compact
    case regular
    case expanded

    public init(width: CGFloat) {
        if width >= 920 {
            self = .expanded
        } else if width >= 640 {
            self = .regular
        } else {
            self = .compact
        }
    }
}
