@testable import BeerHopper
import XCTest

final class FeatureFlagStoreTests: XCTestCase {
    func testFlagsAndCapabilitiesDefaultOff() {
        let store = FeatureFlagStore()

        XCTAssertFalse(store.isEnabled(.discoverySearch))
        XCTAssertFalse(store.hasCapability(.publicDiscovery))
    }

    func testFlagsAndCapabilitiesCanBeEnabledByInjection() {
        let store = FeatureFlagStore(
            flags: [.discoverySearch],
            capabilities: [.publicDiscovery]
        )

        XCTAssertTrue(store.isEnabled(.discoverySearch))
        XCTAssertTrue(store.hasCapability(.publicDiscovery))
    }
}
