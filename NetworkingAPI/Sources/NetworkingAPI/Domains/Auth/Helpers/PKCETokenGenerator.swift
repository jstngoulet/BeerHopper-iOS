//
//  PKCETokenGenerator.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/20/25.
//

import Foundation
import CryptoKit

public struct PKCETokenGenerator {
    
    let codeVerififer: String
    let codeChallenge: String
    
    public init() {
        codeVerififer = PKCETokenGenerator.generateCodeVerifier()
        codeChallenge = PKCETokenGenerator.generateCodeChallenge(
            from: codeVerififer
        )
    }
    
    private static func generateCodeVerifier() -> String {
        UUID().uuidString
    }
    
    private static func generateCodeChallenge(from verifier: String) -> String {
        let data = Data(verifier.utf8)
        let hash = SHA256.hash(data: data)
        return Data(hash)
            .base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
}
