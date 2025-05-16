//
//  GetPostByIDRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

import Foundation

final class GetPostByIDRequest: GETRequest {
    
    init(postID: String) {
        super.init(
            body: nil,
            path: "/api/posts/" + postID,
            contentType: .json
        )
    }
    
}
