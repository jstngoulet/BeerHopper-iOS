//
//  POSTRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

class POSTRequest: Request {
    
    init(body: [String : Any]? = nil, path: String, contentType: Request.ContentType) {
        super.init(body: body, path: path, method: .post, contentType: contentType)
    }
    
}
