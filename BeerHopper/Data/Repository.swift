import Foundation

protocol Repository {
    associatedtype Entity
    associatedtype Identifier: Hashable

    func entity(id: Identifier) async throws -> Entity
}

enum RepositoryError: Error, Equatable {
    case notFound
    case stale
}
