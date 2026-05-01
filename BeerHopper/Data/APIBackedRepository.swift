import Foundation

struct APIBackedRepository<Entity: Decodable, Identifier: Hashable>: Repository {
    private let apiClient: APIClientProtocol
    private let path: (Identifier) -> String
    private let cache: ReadThroughCache<Identifier, Entity>

    init(
        apiClient: APIClientProtocol,
        cache: ReadThroughCache<Identifier, Entity>,
        path: @escaping (Identifier) -> String
    ) {
        self.apiClient = apiClient
        self.cache = cache
        self.path = path
    }

    func entity(id: Identifier) async throws -> Entity {
        if let cached = await self.cache.value(for: id) {
            return cached
        }

        let request = APIRequest<Entity>(path: self.path(id))
        let entity = try await self.apiClient.send(request)
        await self.cache.set(entity, for: id)

        return entity
    }
}
