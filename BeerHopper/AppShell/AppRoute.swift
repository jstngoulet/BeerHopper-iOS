import Foundation

enum AppRoute: Equatable, Hashable {
    case explore
    case search(query: String?)
    case brewery(id: String)
    case brewerySlug(state: String, city: String, slug: String)
    case recipe(id: String)
    case forumPost(id: String)
    case login
    case profile

    var preferredTab: BeerHopperTab {
        switch self {
        case .explore, .brewery, .brewerySlug:
            return .explore

        case .search:
            return .search

        case .recipe:
            return .brew

        case .forumPost:
            return .community

        case .login, .profile:
            return .profile
        }
    }
}
