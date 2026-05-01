@testable import BeerHopper
import XCTest

final class SeededDiscoveryRepositoryTests: XCTestCase {
    func testSearchFiltersByQueryAndScope() async throws {
        let repository = SeededDiscoveryRepository(
            entities: [
                DiscoveryEntity(
                    id: "pike",
                    kind: .brewery,
                    title: "Pike Brewing",
                    subtitle: "Seattle",
                    metadata: "Brewery"
                ),
                DiscoveryEntity(
                    id: "pike-recipe",
                    kind: .recipe,
                    title: "Pike Clone",
                    subtitle: "Recipe",
                    metadata: nil
                )
            ],
            feedItems: []
        )

        let results = try await repository.search(query: "pike", scope: .breweries)

        XCTAssertEqual(results.map(\.id), ["pike"])
    }

    func testEntityDetailThrowsWhenMissing() async {
        let repository = SeededDiscoveryRepository(entities: [], feedItems: [])

        do {
            _ = try await repository.entityDetail(id: "missing", kind: .brewery)
            XCTFail("Expected notFound")
        } catch let error as RepositoryError {
            XCTAssertEqual(error, .notFound)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
