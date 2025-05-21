//
//  GooglePassportProvider.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/21/25.
//
import Foundation
import GoogleSignIn

/// An actor responsible for handling Google Sign-In authentication flows,
/// including configuration, sign-in, token restoration, and sign-out.
/// This wraps `GIDSignIn` for secure and modular usage across the app.

public actor GooglePassportProvider: PassportProvider {
    
    public
    static var isLoggedIn: Bool
    { GIDSignIn.sharedInstance.currentUser != nil }
    
    /// Represents specific errors that may occur during the Google sign-in process.
    public enum GoogleSignInError: LocalizedError {
        case custom(Error)
        case unknownUser
        case invalidToken
        case userCancelled
        
        public var errorDescription: String? {
            switch self {
            case .custom(let err):
                return err.localizedDescription
            case .unknownUser:
                return "User could not be identified"
            case .invalidToken:
                return "The current token is not valid"
            case .userCancelled:
                return "user Cancelled the flow"
            }
        }
    }
    
    /// Handles the redirect URL returned from the Google Sign-In authentication flow.
    /// Should be called from the AppDelegate or SceneDelegate when a URL is opened.
    /// - Parameter url: The URL received during Google Sign-In redirect.
    static func handleSignIn(from url: URL) {
        GIDSignIn.sharedInstance.handle(url)
    }
    
    /// Configures the Google Sign-In SDK with the given client ID.
    /// This must be called before initiating any sign-in attempts.
    /// - Parameter clientIdToken: The iOS client ID from Google Cloud Console.
    public static func configure(_ config: AnyObject?) {
        guard let clientIdToken = config as? String else { return }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: clientIdToken
        )
    }
    
    /// Attempts to restore a previously signed-in user session.
    /// If successful, returns a formatted `Token` for use in the app.
    /// - Throws: An error if restoration fails or the token is invalid.
    /// - Returns: A valid `Token` object if restoration succeeds.
    @discardableResult
    public static func restorePreviousSession() async throws -> Token {
        return try await withCheckedThrowingContinuation { contin in
            GIDSignIn.sharedInstance.restorePreviousSignIn() { user, error in
                if let error = error {
                    contin.resume(throwing: error)
                    return
                }
                
                //  If the user is valid, get a formatted token that aligns with
                //  our token
                guard let user else {
                    contin.resume(throwing: GoogleSignInError.unknownUser)
                    return
                }
                
                //  Now that the user is found, format the token
                guard let idToken = user.idToken?.tokenString
                        , let refreshExpiration = user.refreshToken.expirationDate
                        ?? user.accessToken.expirationDate
                else {
                    contin.resume(throwing: GoogleSignInError.invalidToken)
                    return
                }
                
                let token = Token(
                    idToken,
                    user.refreshToken.tokenString,
                    Int(refreshExpiration.timeIntervalSinceNow)
                )
                
                RESTClient.set(token: token)
                
                contin.resume(returning: token)
            }
        }
    }
    
    /// Signs out the current user from Google Sign-In and clears the session token.
    public static func logout() {
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
    public static func handleSignInButton(
        from viewController: UIViewController
    ) async throws -> Token {
        try await withCheckedThrowingContinuation { contin in
            
            GIDSignIn.sharedInstance.signIn(
                withPresenting: viewController
            ) { result, error in
                if let error = error as NSError? {
                    if error.code == GIDSignInError.canceled.rawValue {
                        contin.resume(throwing: GoogleSignInError.userCancelled)
                        return
                    } else {
                        contin.resume(throwing: error)
                        return
                    }
                }
                
                // If not an error, check the result
                guard let result,
                      let idToken = result.user.idToken?.tokenString,
                      let expirationDate = result.user.refreshToken.expirationDate
                            ?? result.user.accessToken.expirationDate
                else {
                    contin.resume(throwing: GoogleSignInError.invalidToken)
                    return
                }
                
                let token = Token(
                    idToken,
                    "refresh-token",
                    Int(expirationDate.timeIntervalSinceNow)
                )
                
                // Set the token
                RESTClient.set(token: token)
                
                contin.resume(returning: token)
            }
        }
    }
 
    public static func refreshToken() async throws -> Token {
        guard let user = GIDSignIn.sharedInstance.currentUser
        else { throw AuthAPI.AuthError.previousAuthNotFound }
        
        do {
            let updatedUser = try await user.refreshTokensIfNeeded()
            
            //  Now that the user is found, format the token
            guard let idToken = updatedUser.idToken?.tokenString
                    , let refreshExpiration = updatedUser.refreshToken.expirationDate
                        ?? updatedUser.accessToken.expirationDate
            else {
                throw GoogleSignInError.invalidToken
            }
            
            let token = Token(
                idToken,
                updatedUser.refreshToken.tokenString,
                Int(refreshExpiration.timeIntervalSinceNow)
            )
            
            RESTClient.set(token: token)
            
            return token
            
        } catch {
            print("Error refreshing google token: \(error.localizedDescription)")
            throw error
        }
        
    }
}
