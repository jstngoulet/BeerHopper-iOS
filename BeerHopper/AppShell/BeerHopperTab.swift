import Foundation

enum BeerHopperTab: String, CaseIterable, Identifiable {
    case explore
    case search
    case brew
    case community
    case profile

    var id: String {
        return self.rawValue
    }

    var title: String {
        switch self {
        case .explore:
            return "Explore"
        case .search:
            return "Search"
        case .brew:
            return "Brew"
        case .community:
            return "Community"
        case .profile:
            return "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .explore:
            return "safari"
        case .search:
            return "magnifyingglass"
        case .brew:
            return "drop.degreesign"
        case .community:
            return "bubble.left.and.bubble.right"
        case .profile:
            return "person.crop.circle"
        }
    }
}
