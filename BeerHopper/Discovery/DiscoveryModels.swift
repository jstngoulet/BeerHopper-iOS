import Foundation

enum DiscoveryEntityKind: String, CaseIterable, Codable, Equatable, Hashable, Identifiable {
    case brewery
    case beer
    case recipe
    case forumPost

    var id: String {
        return self.rawValue
    }

    var title: String {
        switch self {
        case .brewery:
            return "Breweries"

        case .beer:
            return "Beers"

        case .recipe:
            return "Recipes"

        case .forumPost:
            return "Community"
        }
    }

    var singularTitle: String {
        switch self {
        case .brewery:
            return "Brewery"

        case .beer:
            return "Beer"

        case .recipe:
            return "Recipe"

        case .forumPost:
            return "Post"
        }
    }

    var systemImage: String {
        switch self {
        case .brewery:
            return "building.2"

        case .beer:
            return "mug"

        case .recipe:
            return "book.pages"

        case .forumPost:
            return "bubble.left.and.bubble.right"
        }
    }
}

enum SearchScope: String, CaseIterable, Codable, Equatable, Identifiable {
    case all
    case breweries
    case beers
    case recipes
    case community

    var id: String {
        return self.rawValue
    }

    var title: String {
        switch self {
        case .all:
            return "All"

        case .breweries:
            return "Breweries"

        case .beers:
            return "Beers"

        case .recipes:
            return "Recipes"

        case .community:
            return "Community"
        }
    }

    func accepts(_ kind: DiscoveryEntityKind) -> Bool {
        switch self {
        case .all:
            return true

        case .breweries:
            return kind == .brewery

        case .beers:
            return kind == .beer

        case .recipes:
            return kind == .recipe

        case .community:
            return kind == .forumPost
        }
    }
}

struct DiscoveryEntity: Codable, Equatable, Identifiable, Hashable {
    let id: String
    let kind: DiscoveryEntityKind
    let title: String
    let subtitle: String
    let metadata: String?
}

struct ExploreFeedItem: Codable, Equatable, Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let kind: DiscoveryEntityKind
    let metadata: String?
    let entityID: String
}

struct PublicEntityDetail: Codable, Equatable, Identifiable, Hashable {
    let id: String
    let kind: DiscoveryEntityKind
    let title: String
    let subtitle: String
    let summary: String
    let primaryMetricTitle: String
    let primaryMetricValue: String
    let primaryMetricUnit: String
}
