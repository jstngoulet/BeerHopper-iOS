import Foundation

protocol DeepLinkParsing {
    func parse(_ url: URL) -> AppRoute?
}

struct BeerHopperDeepLinkParser: DeepLinkParsing {
    private let supportedHosts: Set<String>

    init(
        supportedHosts: Set<String> = [
            "beerhopper.com",
            "www.beerhopper.com",
            "beerhopper.me",
            "www.beerhopper.me"
        ]
    ) {
        self.supportedHosts = supportedHosts
    }

    func parse(_ url: URL) -> AppRoute? {
        guard self.isSupported(url) else {
            return nil
        }

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var pathParts = url.path
            .split(separator: "/")
            .map(String.init)

        if pathParts.isEmpty, url.scheme == "beerhopper", let host = url.host {
            pathParts = [host]
        }

        guard let firstPart = pathParts.first else {
            return .explore
        }

        return self.route(firstPart: firstPart, pathParts: pathParts, components: components)
    }

    private func route(
        firstPart: String,
        pathParts: [String],
        components: URLComponents?
    ) -> AppRoute? {
        switch firstPart {
        case "login":
            return .login

        case "profile":
            return .profile

        case "search":
            return .search(query: self.queryValue(from: components))

        case "brewery":
            return self.identifierRoute(pathParts: pathParts, route: AppRoute.brewery)

        case "recipes", "recipe":
            return self.identifierRoute(pathParts: pathParts, route: AppRoute.recipe)

        case "forums", "forum":
            return self.forumRoute(pathParts: pathParts)

        default:
            return self.slugRoute(pathParts: pathParts)
        }
    }

    private func identifierRoute(
        pathParts: [String],
        route: (String) -> AppRoute
    ) -> AppRoute {
        guard pathParts.count >= 2 else {
            return .explore
        }

        return route(pathParts[1])
    }

    private func forumRoute(pathParts: [String]) -> AppRoute {
        guard pathParts.count >= 3, pathParts[1] == "posts" else {
            return .communityRoute
        }

        return .forumPost(id: pathParts[2])
    }

    private func slugRoute(pathParts: [String]) -> AppRoute {
        guard pathParts.count >= 3 else {
            return .explore
        }

        return .brewerySlug(
            state: pathParts[0],
            city: pathParts[1],
            slug: pathParts[2]
        )
    }

    private func queryValue(from components: URLComponents?) -> String? {
        return components?.queryItems?.first(where: { item in
            item.name == "q" || item.name == "query"
        })?.value
    }

    private func isSupported(_ url: URL) -> Bool {
        if url.scheme == "beerhopper" {
            return true
        }

        guard let host = url.host?.lowercased() else {
            return false
        }

        return self.supportedHosts.contains(host)
    }
}

private extension AppRoute {
    static var communityRoute: AppRoute {
        return .forumPost(id: "latest")
    }
}
