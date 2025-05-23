//
//  RegistrationRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

class RegistrationRequest: POSTRequest {
    
    init(
        email: String,
        password: String
    ) {
        super.init(
            body: [
                "email": email,
                "password": password
            ],
            path: "/api/auth/register",
            contentType: .json
        )
    }
}
