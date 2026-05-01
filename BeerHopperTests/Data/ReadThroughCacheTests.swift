@testable import BeerHopper
import XCTest

final class ReadThroughCacheTests: XCTestCase {
    func testReturnsFreshValueAndDropsExpiredValue() async {
        let clock = TestClock(now: Date(timeIntervalSince1970: 100))
        let cache = ReadThroughCache<String, String>(timeToLive: 10, clock: clock)

        await cache.set("fresh", for: "key")
        XCTAssertEqual(await cache.value(for: "key"), "fresh")

        clock.now = Date(timeIntervalSince1970: 111)
        XCTAssertNil(await cache.value(for: "key"))
    }
}

private final class TestClock: ClockProviding {
    var now: Date

    init(now: Date) {
        self.now = now
    }
}
