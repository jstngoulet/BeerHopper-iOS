//
//  InternalPassportProvider.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/21/25.
//
import Foundation

public final class InternalPassportProvider: PassportProvider {
    
    private
    static let tokenIdentifier: String = "com.networkingApi.internal.auth.token"
    
    public
    static func handleSignIn(from url: URL) {
        
    }
    
    @discardableResult
    public
    static func signIn(with email: String, password: String) async throws -> Token {
        let authResult = try await AuthAPI.login(email: email, password: password)
        
        guard let idToken = authResult.idToken,
                let refreshToken = authResult.refreshToken,
        let expiresIn = authResult.expiresIn
        else {
            throw AuthAPI.AuthError.invalidToken
        }
        
        let token = Token(idToken, refreshToken, expiresIn)
        
        //  Store the token and set the auth in the networking provider
        TokenStore.store(token: token, key: tokenIdentifier)
        RESTClient.set(token: token)
        
        return token
    }
    
    @discardableResult
    public static func restorePreviousSession() async throws -> Token {
        guard let token = TokenStore.retrieveToken(withKey: tokenIdentifier)
        else {
            throw AuthAPI.AuthError.previousAuthNotFound
        }
        RESTClient.set(token: token)
        return token
    }
    
    public
    static func logout() {
        TokenStore.clearTokens()
    }
    
    public
    static var isLoggedIn: Bool {
        guard let token = TokenStore.retrieveToken(withKey: tokenIdentifier),
                token.isExpired == false
        else { return false }
        return true
    }
    
    static func refreshToken() async throws -> Token {
        fatalError("Not yet implemented")
    }
    
}
