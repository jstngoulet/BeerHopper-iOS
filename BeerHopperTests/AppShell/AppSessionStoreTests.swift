@testable import BeerHopper
import XCTest

@MainActor
final class AppSessionStoreTests: XCTestCase {
    func testStartsSignedOut() {
        let store = AppSessionStore(initialState: .signedOut)

        XCTAssertFalse(store.state.isSignedIn)
    }

    func testCanMoveBetweenSignedInAndSignedOutStates() {
        let store = AppSessionStore(initialState: .signedOut)

        store.markSignedIn(displayName: "Justin")
        XCTAssertEqual(store.state, .signedIn(displayName: "Justin"))

        store.markSignedOut()
        XCTAssertEqual(store.state, .signedOut)
    }
}
