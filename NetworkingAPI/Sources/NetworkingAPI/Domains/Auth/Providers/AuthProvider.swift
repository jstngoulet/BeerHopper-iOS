//
//  AuthProvider.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/21/25.
//
import Foundation

public
final class AuthProvider: PassportProvider {
    
    public static func handleSignIn(from url: URL) {
        GooglePassportProvider.handleSignIn(from: url)
        InternalPassportProvider.handleSignIn(from: url)
    }
    
    @discardableResult
    public static func restorePreviousSession() async throws -> Token {
        if let googleToken = try? await GooglePassportProvider.restorePreviousSession() {
            return googleToken
        }
        
        if let internalToken = try? await InternalPassportProvider.restorePreviousSession() {
            return internalToken
        }
        
        throw AuthAPI.AuthError.previousAuthNotFound
    }
    
    public static func logout() {
        GooglePassportProvider.logout()
        InternalPassportProvider.logout()
    }
    
    public static var isLoggedIn: Bool {
        GooglePassportProvider.isLoggedIn
        || InternalPassportProvider.isLoggedIn
    }
    
    public static func refreshToken() async throws -> Token {
        if let googleToken = try? await GooglePassportProvider.refreshToken() {
            return googleToken
        }
        
        if let internalToken = try? await InternalPassportProvider.refreshToken() {
            return internalToken
        }
        
        throw AuthAPI.AuthError.tokenRefreshFailed
    }
}
