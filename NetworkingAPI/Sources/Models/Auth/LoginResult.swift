//
//  LoginResult.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import Foundation

public
final class LoginResult: Decodable, Sendable {
    
    public let success: Bool
    public let accessToken: String?
    public let tokenType: String?
    public let refreshToken: String?
    public let expiresIn: Int?
    public let idToken: String?
    public let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case success
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case idToken = "id_token"
        case message
    }
    
    public var tokenExpired: Bool {
        guard let expirationTime = expiresIn else { return false }
        let expiryDate = Date().addingTimeInterval(TimeInterval(expirationTime))
        return Date() > expiryDate
    }
    
    public var isLoggedIn: Bool {
        guard let idToken else { return false }
        return success && !idToken.isEmpty && !tokenExpired
    }
}
