//
//  SearchRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

class SearchRequest: GETRequest {
    
    enum SearchObjectType: String, CaseIterable {
        case yeasts, grains, posts, hops
    }
    
    init(
        query: String?,
        types: [SearchObjectType]? = nil
    ) {
        let params: [String: Any?] = [
            "query": query,
            "types": types?.map({ $0.rawValue }).joined(separator: ",")
        ]
        
        let queryString = params.toQueryString()
        let basePath = "/api/search"
        
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
