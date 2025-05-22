//
//  InternalPassportProvider.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/21/25.
//

/// An internal authentication provider conforming to the `PassportProvider` protocol.
/// Handles email/password-based authentication, session restoration, and token storage.
/// This actor is used for securely managing app-native login flows.

import Foundation

/// Provides internal passport-based authentication for the application.
public actor InternalPassportProvider: PassportProvider {
    
    public static let shared = InternalPassportProvider()
    
    private let tokenIdentifier: String = "com.networkingApi.internal.auth.token"
    
    /// Handles sign-in redirect URLs (no operation for internal provider).
    /// - Parameter url: The incoming URL to handle.
    public func handleSignIn(from url: URL) async {
        // no-op for internal provider
    }
    
    /// Performs sign-in using an email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: A valid authentication `Token`.
    /// - Throws: An error if sign-in fails or token is invalid.
    @discardableResult
    public func signIn(with email: String, password: String) async throws -> Token {
        let authResult = try await AuthAPI.login(email: email, password: password)
        
        guard let idToken = authResult.idToken,
              let refreshToken = authResult.refreshToken,
              let expiresIn = authResult.expiresIn
        else {
            throw AuthAPI.AuthError.invalidToken
        }
        
        let token = Token(idToken, refreshToken, expiresIn)
        
        // Store the token and set the auth in the networking provider
        TokenStore.store(token: token, key: tokenIdentifier)
        RESTClient.set(token: token)
        
        return token
    }
    
    /// Attempts to restore a previously saved authentication session.
    /// - Returns: A valid `Token` if restoration succeeds.
    /// - Throws: An error if no previous session is found.
    @discardableResult
    public func restorePreviousSession() async throws -> Token {
        guard let token = TokenStore.retrieveToken(withKey: tokenIdentifier)
        else {
            throw AuthAPI.AuthError.previousAuthNotFound
        }
        RESTClient.set(token: token)
        return token
    }
    
    /// Logs the user out and clears stored authentication data.
    public func logout() async {
        TokenStore.deleteToken(withKey: tokenIdentifier)
    }
    
    /// Checks whether a user is currently logged in and the token is valid.
    /// - Returns: A Boolean indicating the login status.
    public func isLoggedIn() async -> Bool {
        guard let token = TokenStore.retrieveToken(withKey: tokenIdentifier),
              token.isExpired == false
        else { return false }
        return true
    }
    
    /// Refreshes the authentication token.
    /// - Throws: An error indicating the method is not yet implemented.
    /// - Returns: A refreshed `Token`.
    public func refreshToken() async throws -> Token {
        fatalError("Not yet implemented")
    }
}

// MARK: - Static interface for InternalPassportProvider (forwards to shared)
extension InternalPassportProvider {
    
    /// Checks if a user is currently logged in using the internal authentication system.
    /// - Returns: A Boolean indicating the login status.
    public static func isLoggedIn() async -> Bool {
        await shared.isLoggedIn()
    }
    
    /// Handles a sign-in redirect URL (unused in internal auth).
    /// - Parameter url: The incoming URL to handle.
    public static func handleSignIn(from url: URL) async {
        await shared.handleSignIn(from: url)
    }
    
    /// Attempts to restore a previously saved internal authentication session.
    /// - Returns: A valid `Token` object if restoration succeeds.
    /// - Throws: An error if the session cannot be restored.
    @discardableResult
    public static func restorePreviousSession() async throws -> Token {
        try await shared.restorePreviousSession()
    }
    
    /// Logs the user out and clears stored authentication data.
    public static func logout() async {
        await shared.logout()
    }
    
    /// Refreshes the internal authentication token (not yet implemented).
    /// - Returns: A refreshed `Token` object.
    /// - Throws: An error if the method is called.
    public static func refreshToken() async throws -> Token {
        try await shared.refreshToken()
    }
    
    /// Performs a login using the internal email/password flow.
    /// - Parameters:
    ///   - email: The user’s email address.
    ///   - password: The user’s password.
    /// - Returns: A `Token` if login succeeds.
    /// - Throws: An error if the login fails.
    @discardableResult
    public static func signIn(with email: String, password: String) async throws -> Token {
        try await shared.signIn(with: email, password: password)
    }
}
