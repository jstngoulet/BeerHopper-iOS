//
//  Request.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

class Request: NSObject {
    
    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        case patch = "PATCH"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
    
    var body: [String: Any]?
    var path: String
    var method: HTTPMethod
    var contentType: ContentType = .json
    
    init(
        body: [String : Any]? = nil,
        path: String,
        method: HTTPMethod,
        contentType: ContentType = .json
    ) {
        self.body = body
        self.path = path
        self.method = method
        self.contentType = contentType
    }
}
