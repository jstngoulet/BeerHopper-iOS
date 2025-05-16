//
//  GetPopularPostsRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

final class GetPopularPostsRequest: GETRequest {
    
    enum SortOption: String {
        case recent = "recent"
    }
    
    init(
        page: Int?,
        limit: Int?,
        sort: SortOption = .recent
    ) {
        
        let params: [String: Any?] = [
            "page": page,
            "limit": limit
        ]
        
        let queryString = params.toQueryString()
        let basePath = "/api/posts/popular/" + sort.rawValue  //  There will be more sort options
        
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
