@testable import BeerHopper
import XCTest

final class ReadThroughCacheTests: XCTestCase {
    func testReturnsFreshValueAndDropsExpiredValue() async {
        let clock = TestClock(now: Date(timeIntervalSince1970: 100))
        let cache = ReadThroughCache<String, String>(timeToLive: 10, clock: clock)

        await cache.set("fresh", for: "key")
        let freshValue = await cache.value(for: "key")
        XCTAssertEqual(freshValue, "fresh")

        clock.now = Date(timeIntervalSince1970: 111)
        let expiredValue = await cache.value(for: "key")
        XCTAssertNil(expiredValue)
    }
}

private final class TestClock: ClockProviding {
    var now: Date

    init(now: Date) {
        self.now = now
    }
}
