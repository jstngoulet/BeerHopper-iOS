import Foundation

protocol DiscoveryRepository {
    func search(query: String, scope: SearchScope) async throws -> [DiscoveryEntity]
    func exploreFeed() async throws -> [ExploreFeedItem]
    func entityDetail(id: String, kind: DiscoveryEntityKind) async throws -> PublicEntityDetail
}

struct APIDiscoveryRepository: DiscoveryRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func search(query: String, scope: SearchScope) async throws -> [DiscoveryEntity] {
        let request = APIRequest<[DiscoveryEntity]>(
            path: "/search",
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "scope", value: scope.rawValue)
            ]
        )

        return try await self.apiClient.send(request)
    }

    func exploreFeed() async throws -> [ExploreFeedItem] {
        let request = APIRequest<[ExploreFeedItem]>(path: "/explore/feed")
        return try await self.apiClient.send(request)
    }

    func entityDetail(id: String, kind: DiscoveryEntityKind) async throws -> PublicEntityDetail {
        let request = APIRequest<PublicEntityDetail>(
            path: "/public/entities/\(kind.rawValue)/\(id)"
        )

        return try await self.apiClient.send(request)
    }
}

struct SeededDiscoveryRepository: DiscoveryRepository {
    private let entities: [DiscoveryEntity]
    private let feedItems: [ExploreFeedItem]

    init(
        entities: [DiscoveryEntity] = SeededDiscoveryRepository.defaultEntities,
        feedItems: [ExploreFeedItem] = SeededDiscoveryRepository.defaultFeedItems
    ) {
        self.entities = entities
        self.feedItems = feedItems
    }

    func search(query: String, scope: SearchScope) async throws -> [DiscoveryEntity] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalizedQuery.isEmpty else {
            return self.entities.filter { entity in
                scope.accepts(entity.kind)
            }
        }

        return self.entities.filter { entity in
            scope.accepts(entity.kind)
                && (
                    entity.title.lowercased().contains(normalizedQuery)
                        || entity.subtitle.lowercased().contains(normalizedQuery)
                        || (entity.metadata?.lowercased().contains(normalizedQuery) ?? false)
                )
        }
    }

    func exploreFeed() async throws -> [ExploreFeedItem] {
        return self.feedItems
    }

    func entityDetail(id: String, kind: DiscoveryEntityKind) async throws -> PublicEntityDetail {
        guard let entity = self.entities.first(where: { candidate in
            candidate.id == id && candidate.kind == kind
        }) else {
            throw RepositoryError.notFound
        }

        return PublicEntityDetail(
            id: entity.id,
            kind: entity.kind,
            title: entity.title,
            subtitle: entity.subtitle,
            summary: "Public details are read-only until the matching signed-in flow is available.",
            primaryMetricTitle: entity.kind.singularTitle,
            primaryMetricValue: "Public",
            primaryMetricUnit: "view"
        )
    }

    private static let defaultEntities: [DiscoveryEntity] = [
        DiscoveryEntity(
            id: "pike-brewing",
            kind: .brewery,
            title: "Pike Brewing",
            subtitle: "Seattle, WA",
            metadata: "Public brewery"
        ),
        DiscoveryEntity(
            id: "rainier-lager",
            kind: .beer,
            title: "Rainier Lager",
            subtitle: "Crisp lager profile",
            metadata: "Beer"
        ),
        DiscoveryEntity(
            id: "west-coast-ipa",
            kind: .recipe,
            title: "West Coast IPA",
            subtitle: "Brew-day recipe shell",
            metadata: "Recipe"
        ),
        DiscoveryEntity(
            id: "hop-schedule-thread",
            kind: .forumPost,
            title: "Dry hop schedule notes",
            subtitle: "Community discussion",
            metadata: "Forum"
        )
    ]

    private static let defaultFeedItems: [ExploreFeedItem] = [
        ExploreFeedItem(
            id: "feed-pike-brewing",
            title: "Pike Brewing",
            subtitle: "Public brewery profile",
            kind: .brewery,
            metadata: "Seattle",
            entityID: "pike-brewing"
        ),
        ExploreFeedItem(
            id: "feed-west-coast-ipa",
            title: "West Coast IPA",
            subtitle: "Recipe shell preview",
            kind: .recipe,
            metadata: "Recipe",
            entityID: "west-coast-ipa"
        )
    ]
}
