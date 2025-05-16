//
//  SearchRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

class SearchRequest: GETRequest {
    
    init(query: String?) {
        let params: [String: Any?] = [
            "query": query
        ]
        
        let queryString = params.toQueryString()
        
        let fullPath = queryString.isEmpty
            ? "/api/search"
            : "/api/search?\(queryString)"
        
        super.init(
            body: nil,
            path: fullPath,
            contentType: .json
        )
    }
}
