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
        let loadedTokens = try await vault.load()
        let accessToken = try await vault.currentAccessToken()

        XCTAssertEqual(loadedTokens, tokens)
        XCTAssertEqual(accessToken, "access-token")

        try await vault.clear()
        let clearedTokens = try await vault.load()
        XCTAssertNil(clearedTokens)
    }
}
