import Combine
import DesignSystem
import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published
    var query: String

    @Published
    var scope: SearchScope

    @Published
    private(set) var state: BHAsyncState<[DiscoveryEntity]>

    private let repository: DiscoveryRepository

    init(
        repository: DiscoveryRepository,
        initialQuery: String = "",
        initialScope: SearchScope = .all
    ) {
        self.repository = repository
        self.query = initialQuery
        self.scope = initialScope
        self.state = .idle
    }

    func submitSearch() {
        Task {
            await self.search()
        }
    }

    func search() async {
        self.state = .loading

        do {
            let results = try await self.repository.search(query: self.query, scope: self.scope)
            self.state = results.isEmpty ? .empty : .loaded(results)
        } catch {
            self.state = .failed(error.localizedDescription)
        }
    }

    func selectScope(_ scope: SearchScope) {
        self.scope = scope
        self.submitSearch()
    }
}
