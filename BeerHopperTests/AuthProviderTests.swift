//
//  AuthProviderTests.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/22/25.
//
import XCTest
@testable import BeerHopper
@testable import NetworkingAPI

final class AuthProviderTests: XCTestCase {
    
    func test_restoreSession_UsesFirstSuccessfulProvider() async throws {
        let expectedToken = Token("abc", "refresh", 3600)
        let failingProvider = MockPassportProvider(id: "Fail", shouldSucceed: false)
        let workingProvider = MockPassportProvider(id: "Success", shouldSucceed: true, token: expectedToken)
        
        let auth = AuthProvider(providers: [failingProvider, workingProvider])
        
        let result = try await auth.restorePreviousSession()
        XCTAssertEqual(result.idToken, expectedToken.idToken)
    }
    
    func test_restoreSession_ThrowsWhenAllFail() async {
        let providers = [
            MockPassportProvider(id: "Fail1", shouldSucceed: false),
            MockPassportProvider(id: "Fail2", shouldSucceed: false)
        ]
        let auth = AuthProvider(providers: providers)
        
        do {
            _ = try await auth.restorePreviousSession()
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssertTrue(error is AuthAPI.AuthError)
        }
    }
    
    func test_isLoggedIn_ReturnsTrueIfAnyProviderIsLoggedIn() async {
        let providers = [
            MockPassportProvider(id: "Fail", shouldSucceed: false),
            MockPassportProvider(id: "Win", shouldSucceed: true)
        ]
        let auth = AuthProvider(providers: providers)
        
        let result = await auth.isLoggedIn()
        XCTAssertTrue(result)
    }
}
