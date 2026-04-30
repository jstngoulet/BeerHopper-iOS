@testable import BeerHopper
import XCTest

@MainActor
final class AppRouterTests: XCTestCase {
    func testRouteSelectsPreferredTab() {
        let router = AppRouter()

        router.route(to: .forumPost(id: "abc123"))

        XCTAssertEqual(router.selectedTab, .community)
        XCTAssertEqual(router.currentRoute, .forumPost(id: "abc123"))
    }

    func testSearchRouteSelectsSearchTab() {
        let router = AppRouter()

        router.route(to: .search(query: "lager"))

        XCTAssertEqual(router.selectedTab, .search)
        XCTAssertEqual(router.currentRoute, .search(query: "lager"))
    }
}
