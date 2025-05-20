//
//  GetAllPostsRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

import Foundation

final class GetAllPostsRequest: GETRequest {
    
    init(
        page: Int?,
        limit: Int?
    ) {
        
        let params: [String: Any?] = [
            "page": page,
            "limit": limit
        ]
        
        let queryString = params.toQueryString()
        let basePath = "/api/posts"
        
        let fullPath = queryString.isEmpty
            ? basePath
            : [basePath, queryString].joined(separator: "?")
        
        super.init(
            body: nil,
            path: fullPath,
            contentType: .json
        )
    }
    
}
