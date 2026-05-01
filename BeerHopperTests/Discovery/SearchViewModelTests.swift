@testable import BeerHopper
import DesignSystem
import XCTest

@MainActor
final class SearchViewModelTests: XCTestCase {
    func testSearchLoadsScopedResults() async {
        let repository = StubDiscoveryRepository(
            searchResults: [
                DiscoveryEntity(
                    id: "pike",
                    kind: .brewery,
                    title: "Pike Brewing",
                    subtitle: "Seattle",
                    metadata: "Brewery"
                )
            ]
        )
        let viewModel = SearchViewModel(
            repository: repository,
            initialQuery: "pike",
            initialScope: .breweries
        )

        await viewModel.search()

        guard case .loaded(let results) = viewModel.state else {
            XCTFail("Expected loaded search state")
            return
        }

        XCTAssertEqual(results.map(\.title), ["Pike Brewing"])
        XCTAssertEqual(repository.lastQuery, "pike")
        XCTAssertEqual(repository.lastScope, .breweries)
    }

    func testSearchMapsEmptyResults() async {
        let viewModel = SearchViewModel(repository: StubDiscoveryRepository(searchResults: []))

        await viewModel.search()

        guard case .empty = viewModel.state else {
            XCTFail("Expected empty search state")
            return
        }
    }
}

@MainActor
final class ExploreFeedViewModelTests: XCTestCase {
    func testLoadPublishesFeedItems() async {
        let repository = StubDiscoveryRepository(
            feedItems: [
                ExploreFeedItem(
                    id: "feed-pike",
                    title: "Pike Brewing",
                    subtitle: "Public brewery",
                    kind: .brewery,
                    metadata: "Seattle",
                    entityID: "pike"
                )
            ]
        )
        let viewModel = ExploreFeedViewModel(repository: repository)

        await viewModel.load()

        guard case .loaded(let items) = viewModel.state else {
            XCTFail("Expected loaded feed state")
            return
        }

        XCTAssertEqual(items.map(\.entityID), ["pike"])
    }
}

@MainActor
final class EntityDetailViewModelTests: XCTestCase {
    func testLoadPublishesEntityDetail() async {
        let detail = PublicEntityDetail(
            id: "pike",
            kind: .brewery,
            title: "Pike Brewing",
            subtitle: "Seattle",
            summary: "Public profile",
            primaryMetricTitle: "Brewery",
            primaryMetricValue: "Public",
            primaryMetricUnit: "view"
        )
        let repository = StubDiscoveryRepository(entityDetail: detail)
        let viewModel = EntityDetailViewModel(repository: repository, id: "pike", kind: .brewery)

        await viewModel.load()

        guard case .loaded(let loadedDetail) = viewModel.state else {
            XCTFail("Expected loaded detail state")
            return
        }

        XCTAssertEqual(loadedDetail, detail)
        XCTAssertEqual(repository.lastDetailID, "pike")
        XCTAssertEqual(repository.lastDetailKind, .brewery)
    }
}

private final class StubDiscoveryRepository: DiscoveryRepository {
    private let searchResults: [DiscoveryEntity]
    private let feedItems: [ExploreFeedItem]
    private let entityDetail: PublicEntityDetail?

    private(set) var lastQuery: String?
    private(set) var lastScope: SearchScope?
    private(set) var lastDetailID: String?
    private(set) var lastDetailKind: DiscoveryEntityKind?

    init(
        searchResults: [DiscoveryEntity] = [],
        feedItems: [ExploreFeedItem] = [],
        entityDetail: PublicEntityDetail? = nil
    ) {
        self.searchResults = searchResults
        self.feedItems = feedItems
        self.entityDetail = entityDetail
    }

    func search(query: String, scope: SearchScope) async throws -> [DiscoveryEntity] {
        self.lastQuery = query
        self.lastScope = scope
        return self.searchResults
    }

    func exploreFeed() async throws -> [ExploreFeedItem] {
        return self.feedItems
    }

    func entityDetail(id: String, kind: DiscoveryEntityKind) async throws -> PublicEntityDetail {
        self.lastDetailID = id
        self.lastDetailKind = kind

        guard let entityDetail = self.entityDetail else {
            throw RepositoryError.notFound
        }

        return entityDetail
    }
}
