//
//  GooglePassportProvider.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/21/25.
//

/// An actor responsible for managing Google Sign-In authentication flows,
/// including configuration, login, token restoration, logout, and token refresh.
/// Wraps the `GIDSignIn` SDK to provide a concurrency-safe interface that
/// conforms to the shared `PassportProvider` protocol.

import Foundation
@preconcurrency import GoogleSignIn

/// Provides Google OAuth2 authentication functionality using Google Sign-In.
public actor GooglePassportProvider: PassportProvider {
    
    public static let shared = GooglePassportProvider()
    
    /// Checks if there is a currently logged-in Google user.
    public func isLoggedIn() async -> Bool {
        GIDSignIn.sharedInstance.currentUser != nil
    }
    
    /// Represents specific errors that may occur during the Google sign-in process.
    public enum GoogleSignInError: LocalizedError {
        case custom(Error)
        case unknownUser
        case invalidToken
        case userCancelled
        
        public var errorDescription: String? {
            switch self {
            case .custom(let err): return err.localizedDescription
            case .unknownUser: return "User could not be identified"
            case .invalidToken: return "The current token is not valid"
            case .userCancelled: return "User cancelled the sign-in flow"
            }
        }
    }
    
    /// Configures the Google Sign-In SDK with the given client ID.
    /// This must be called before initiating any sign-in attempts.
    /// - Parameter clientIdToken: The iOS client ID from Google Cloud Console.
    public func configure(_ clientIdToken: String) async {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientIdToken)
    }
    
    /// Handles the redirect URL returned from the Google Sign-In authentication flow.
    /// Should be called from the AppDelegate or SceneDelegate when a URL is opened.
    /// - Parameter url: The URL received during Google Sign-In redirect.
    public func handleSignIn(from url: URL) async {
        GIDSignIn.sharedInstance.handle(url)
    }
    
    /// Attempts to restore a previously signed-in user session.
    /// If successful, returns a formatted `Token` for use in the app.
    /// - Throws: An error if restoration fails or the token is invalid.
    /// - Returns: A valid `Token` object if restoration succeeds.
    @discardableResult
    public func restorePreviousSession() async throws -> Token {
        try await withCheckedThrowingContinuation { contin in
            GIDSignIn.sharedInstance.restorePreviousSignIn() { user, error in
                if let error = error {
                    contin.resume(throwing: error)
                    return
                }
                
                guard let user = user,
                      let idToken = user.idToken?.tokenString,
                      let refreshExpiration = user.refreshToken.expirationDate ?? user.accessToken.expirationDate
                else {
                    contin.resume(throwing: GoogleSignInError.invalidToken)
                    return
                }
                
                let token = Token(idToken, user.refreshToken.tokenString, Int(refreshExpiration.timeIntervalSinceNow))
                RESTClient.set(token: token)
                contin.resume(returning: token)
            }
        }
    }
    
    /// Signs out the current user from Google Sign-In and clears the session token.
    public func logout() async {
        GIDSignIn.sharedInstance.signOut()
        RESTClient.set(token: nil)
    }
    
    /// Handles a sign-in flow initiated by a Google Sign-In button.
    /// Presents the sign-in UI from the provided view controller and returns a `Token`.
    /// - Parameter viewController: The presenting view controller from which to show the Google sign-in flow.
    /// - Throws: An error if the sign-in fails or the token cannot be generated.
    /// - Returns: A valid `Token` object on successful sign-in.
    @MainActor
    @discardableResult
    public func handleSignInButton(from viewController: UIViewController) async throws -> Token {
        try await withCheckedThrowingContinuation { contin in
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
                if let error = error as NSError?, error.code == GIDSignInError.canceled.rawValue {
                    contin.resume(throwing: GoogleSignInError.userCancelled)
                    return
                } else if let error = error {
                    contin.resume(throwing: error)
                    return
                }
                
                guard let result = result,
                      let idToken = result.user.idToken?.tokenString,
                      let expirationDate = result.user.refreshToken.expirationDate ?? result.user.accessToken.expirationDate
                else {
                    contin.resume(throwing: GoogleSignInError.invalidToken)
                    return
                }
                
                let token = Token(idToken, result.user.refreshToken.tokenString, Int(expirationDate.timeIntervalSinceNow))
                RESTClient.set(token: token)
                contin.resume(returning: token)
            }
        }
    }
    
    /// Refreshes the current user's token if needed.
    /// - Throws: An error if refreshing fails or token is invalid.
    /// - Returns: A valid refreshed `Token` object.
    public func refreshToken() async throws -> Token {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            throw AuthAPI.AuthError.previousAuthNotFound
        }
        
        do {
            let updatedUser = try await user.refreshTokensIfNeeded()
            guard let idToken = updatedUser.idToken?.tokenString,
                  let refreshExpiration = updatedUser.refreshToken.expirationDate ?? updatedUser.accessToken.expirationDate
            else {
                throw GoogleSignInError.invalidToken
            }
            
            let token = Token(idToken, updatedUser.refreshToken.tokenString, Int(refreshExpiration.timeIntervalSinceNow))
            RESTClient.set(token: token)
            return token
            
        } catch {
            print("Error refreshing google token: \(error.localizedDescription)")
            throw error
        }
    }
}

// MARK: - Static interface for GooglePassportProvider (forwards to shared)
extension GooglePassportProvider {
    
    /// Checks whether a user is currently signed in to Google.
    /// - Returns: A Boolean indicating the login status.
    public static func isLoggedIn() async ->  Bool {
        await shared.isLoggedIn()
    }
    
    /// Handles a Google Sign-In redirect URL.
    /// - Parameter url: The URL received during sign-in redirect.
    public static func handleSignIn(from url: URL) async {
        await shared.handleSignIn(from: url)
    }
    
    /// Configures the Google Sign-In SDK with a client ID.
    /// - Parameter clientIdToken: The iOS client ID from Google Cloud Console.
    public static func configure(_ clientIdToken: String) async {
        await shared.configure(clientIdToken)
    }
    
    /// Restores a previously signed-in session.
    /// - Returns: A valid `Token` object if restoration succeeds.
    /// - Throws: An error if restoration fails or no user is available.
    @discardableResult
    public static func restorePreviousSession() async throws -> Token {
        try await shared.restorePreviousSession()
    }
    
    /// Signs the current user out from Google Sign-In.
    public static func logout() async {
        await shared.logout()
    }
    
    /// Begins the Google Sign-In flow from the specified view controller.
    /// - Parameter viewController: The view controller to present the sign-in flow.
    /// - Returns: A valid `Token` object on successful sign-in.
    /// - Throws: An error if sign-in fails or is cancelled.
    @MainActor
    @discardableResult
    public static func handleSignInButton(
        from viewController: UIViewController
    ) async throws -> Token {
        try await shared.handleSignInButton(from: viewController)
    }
    
    /// Refreshes the current user's authentication token if needed.
    /// - Returns: A refreshed `Token`.
    /// - Throws: An error if the token could not be refreshed.
    public static func refreshToken() async throws -> Token {
        try await shared.refreshToken()
    }
}
