//
//  LoginTokenChallengeRequest.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/20/25.
//

import Foundation

final class LoginTokenChallengeRequest: POSTRequest {
    
    init(
        email: String,
        password: String,
        clientToken: String
    ) {
        super.init(
            body: [
                "email": email,
                "password": password,
                "token": clientToken
            ],
            path: "/api/auth/login/challenge",
            contentType: .json
        )
    }
    
}
