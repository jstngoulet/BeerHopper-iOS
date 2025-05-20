//
//  CommentOnPostRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

import Foundation

final class CommentOnPostRequest: POSTRequest {
    
    init(
        postId: String,
        comment: String
    ) {
        super.init(
            body: [
                "content": comment
            ],
            path: [
                "/api/posts/",
                postId,
                "/comments"
            ].joined(),
            contentType: .json
        )
    }
    
}
