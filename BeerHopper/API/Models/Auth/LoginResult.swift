//
//  LoginResult.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import Foundation

class LoginResult: Decodable {
    
    let success: Bool
    let accessToken: String?
    let tokenType: String?
    let refreshToken: String?
    let expiresIn: Int?
    let idToken: String?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case success
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case idToken = "id_token"
        case message
    }
    
    var tokenExpired: Bool {
        guard let expirationTime = expiresIn else { return false }
        let expiryDate = Date().addingTimeInterval(TimeInterval(expirationTime))
        return Date() > expiryDate
    }
    
    var isLoggedIn: Bool {
        guard let idToken else { return false }
        return success && !idToken.isEmpty && !tokenExpired
    }
}
