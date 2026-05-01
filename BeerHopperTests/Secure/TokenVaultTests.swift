@testable import BeerHopper
import XCTest

final class TokenVaultTests: XCTestCase {
    func testInMemoryTokenVaultRoundTripsAndClearsTokens() async throws {
        let vault = InMemoryTokenVault()
        let tokens = AuthTokens(
            accessToken: "access-token",
            refreshToken: "refresh-token",
            expiresAt: Date(timeIntervalSince1970: 100)
        )

        try await vault.save(tokens)
        XCTAssertEqual(try await vault.load(), tokens)
        XCTAssertEqual(try await vault.currentAccessToken(), "access-token")

        try await vault.clear()
        XCTAssertNil(try await vault.load())
    }
}
