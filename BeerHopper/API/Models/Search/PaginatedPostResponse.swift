//
//  PaginatedPostResponse.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


struct PaginatedPostResponse: Decodable {
    let total: Int
    let page: Int
    let limit: Int
    let data: [Post]
}