//
//  MockPassportProvider.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/22/25.
//
//
/// A mock implementation of `PassportProvider` used for testing authentication flows.
/// Can simulate either success or failure based on initialization parameters.
import Foundation

public actor MockPassportProvider: PassportProvider {
    
    /// Determines whether this provider should simulate a successful result.
    let shouldSucceed: Bool
    
    /// The token to return on successful simulation.
    let token: Token
    
    /// An identifier for test diagnostics.
    let identifier: String
    
    /// Initializes a new mock provider with configurable behavior.
    /// - Parameters:
    ///   - id: A test identifier string.
    ///   - shouldSucceed: Indicates whether the provider should simulate a successful auth flow.
    ///   - token: The token to return on success (defaults to a generic token).
    public init(
        id: String,
        shouldSucceed: Bool,
        token: Token = Token("id", "refresh", 3600)
    ) {
        self.shouldSucceed = shouldSucceed
        self.token = token
        self.identifier = id
    }
    
    /// Mocks handling a sign-in URL (no-op in test).
    public func handleSignIn(from url: URL) async {}
    
    /// Mocks logging out (no-op in test).
    public func logout() async { }
    
    /// Returns whether the mock should simulate a logged-in state.
    public func isLoggedIn() async -> Bool { shouldSucceed }
    
    /// Mocks restoring a previous session.
    /// - Returns: A token if successful.
    /// - Throws: `AuthAPI.AuthError.previousAuthNotFound` if configured to fail.
    public func restorePreviousSession() async throws -> Token {
        if shouldSucceed { return token }
        throw AuthAPI.AuthError.previousAuthNotFound
    }
    
    /// Mocks refreshing a token.
    /// - Returns: A token if successful.
    /// - Throws: `AuthAPI.AuthError.tokenRefreshFailed` if configured to fail.
    public func refreshToken() async throws -> Token {
        if shouldSucceed { return token }
        throw AuthAPI.AuthError.tokenRefreshFailed
    }
}
