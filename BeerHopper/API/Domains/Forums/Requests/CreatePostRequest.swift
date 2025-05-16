//
//  CreatePostRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

import Foundation

final class CreatePostRequest: POSTRequest {
    
    init(
        title: String,
        content: String
    ) {
        super.init(
            body: [
                "title": title,
                "content": content
            ],
            path: "/api/posts",
            contentType: .json
        )
    }
    
}
