//
//  ReactToPostRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

import Foundation

final class ReactToPostRequest: POSTRequest {
    
    init(
        postId: String,
        reaction: UserPostReaction?
    ) {
        super.init(
            body: [
                "type": reaction?.rawValue ?? "NONE"
            ],
            path: [
                "/api/posts/"
                , postId
                , "/like"
            ].joined(),
            contentType: .json
        )
    }
    
}
