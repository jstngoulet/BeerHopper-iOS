//
//  AuthProvider.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/21/25.
//

import Foundation

/// Coordinates authentication by delegating to injected PassportProvider implementations.
/// Tries providers in priority order (e.g., Google, then Internal).
public actor AuthProvider {
    
    private let providers: [PassportProvider]
    
    /// Initializes the AuthProvider with one or more PassportProvider instances.
    /// The first provider in the array is given highest priority.
    /// - Parameter providers: The authentication strategies to attempt in order.
    public init(providers: [PassportProvider]) {
        self.providers = providers
    }
    
    /// Handles authentication callback URLs forwarded from the application.
    /// - Parameter url: The URL received during OAuth or SSO redirects.
    public func handleSignIn(from url: URL) async {
        for provider in providers {
            await provider.handleSignIn(from: url)
        }
    }
    
    /// Attempts to restore a previously signed-in session from any provider.
    /// - Returns: A valid token if any provider succeeds.
    /// - Throws: An error if no session could be restored.
    @discardableResult
    public func restorePreviousSession() async throws -> Token {
        for provider in providers {
            if let token = try? await provider.restorePreviousSession() {
                return token
            }
        }
        throw AuthAPI.AuthError.previousAuthNotFound
    }
    
    /// Signs the user out of all providers.
    public func logout() async {
        for provider in providers {
            await provider.logout()
        }
    }
    
    /// Checks whether any provider reports an active session.
    /// - Returns: `true` if at least one provider is logged in.
    public func isLoggedIn() async -> Bool {
        for provider in providers {
            if await provider.isLoggedIn() {
                return true
            }
        }
        return false
    }
    
    /// Attempts to refresh the user's token from the first available provider.
    /// - Returns: A refreshed token.
    /// - Throws: An error if none of the providers could refresh successfully.
    public func refreshToken() async throws -> Token {
        for provider in providers {
            if let token = try? await provider.refreshToken() {
                return token
            }
        }
        throw AuthAPI.AuthError.tokenRefreshFailed
    }
}
