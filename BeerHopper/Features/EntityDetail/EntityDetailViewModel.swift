import Combine
import DesignSystem
import Foundation

@MainActor
final class EntityDetailViewModel: ObservableObject {
    @Published
    private(set) var state: BHAsyncState<PublicEntityDetail>

    private let repository: DiscoveryRepository
    private let id: String
    private let kind: DiscoveryEntityKind

    init(repository: DiscoveryRepository, id: String, kind: DiscoveryEntityKind) {
        self.repository = repository
        self.id = id
        self.kind = kind
        self.state = .idle
    }

    func load() async {
        self.state = .loading

        do {
            self.state = .loaded(try await self.repository.entityDetail(id: self.id, kind: self.kind))
        } catch {
            self.state = .failed(error.localizedDescription)
        }
    }
}
