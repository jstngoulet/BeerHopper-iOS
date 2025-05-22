//
//  LoginRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import Foundation

class LoginRequest: POSTRequest {
    
    init(
        email: String,
        password: String,
        authCode: String? = nil     //  If supports PKCE
    ) {
        super.init(
            body: [
                "email": email,
                "password": password,
                "authCode": authCode ?? NSNull()
            ],
            path: "/api/auth/login",
            contentType: .json
        )
    }
}
