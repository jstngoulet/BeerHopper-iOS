import Combine
import DesignSystem
import Foundation

@MainActor
final class ExploreFeedViewModel: ObservableObject {
    @Published
    private(set) var state: BHAsyncState<[ExploreFeedItem]>

    private let repository: DiscoveryRepository

    init(repository: DiscoveryRepository) {
        self.repository = repository
        self.state = .idle
    }

    func load() async {
        self.state = .loading

        do {
            let items = try await self.repository.exploreFeed()
            self.state = items.isEmpty ? .empty : .loaded(items)
        } catch {
            self.state = .failed(error.localizedDescription)
        }
    }
}
