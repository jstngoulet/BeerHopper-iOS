//
//  TokenStore.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/20/25.
//

import Foundation
import Security

/// Represents an authentication token returned from the server,
/// including ID token, refresh token, expiration time, and optional computed expiration date.
public struct Token: Codable, Sendable {
    public let idToken: String
    public let refreshToken: String
    public let expiresIn: Int
    public var isExpired: Bool { expiresDate >= Date() }
    public private(set) var expiresDate: Date = .distantPast
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idToken = try container.decode(String.self, forKey: .idToken)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        self.expiresDate = Date().addingTimeInterval(TimeInterval(expiresIn))
    }
    
    init(_ idToken: String, _ refreshToken: String, _ expiresIn: Int) {
        self.idToken = idToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}

/// An actor responsible for securely storing, retrieving, and managing authentication tokens
/// using the system Keychain. Thread-safe and isolated by design.
final actor TokenStore {
    
    private static let service: String = "com.beerhopper.ios"
    
    /// Stores a `Token` object securely in the Keychain.
    /// - Parameters:
    ///   - token: The token object containing auth details.
    ///   - key: A unique identifier to associate with this token (e.g., "id_token").
    static func store(
        token: Token,
        key: String
    ) {
        guard let data = try? JSONEncoder().encode(token)
        else { return }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ]
        
        //  Delete if already present
        SecItemDelete(query as CFDictionary)
        
        let newAttribute: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        
        let status = SecItemAdd(newAttribute as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Failed to store token securely: \(status)")
        }
    }
    
    /// Retrieves a stored `Token` from the Keychain.
    /// - Parameter key: The identifier used when storing the token.
    /// - Returns: A `Token` object if found and successfully decoded, or nil if not present.
    static func retrieveToken(withKey key: String) -> Token? {
        let query:[CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        //  If data found, map it to a token and release it
        if status == errSecSuccess,
           let data = result as? Data,
           let token = try? JSONDecoder().decode(
            Token.self,
            from: data
           ) {
            return token
        }
        
        //  No token found
        return nil
    }
    
    /// Deletes a specific token from the Keychain.
    /// - Parameter key: The identifier associated with the token to delete.
    static func deleteToken(withKey key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    /// Clears all tokens stored under the BeerHopper service identifier in the Keychain.
    static func clearTokens() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
