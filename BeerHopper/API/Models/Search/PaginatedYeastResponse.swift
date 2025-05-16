//
//  PaginatedYeastResponse.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


struct PaginatedYeastResponse: Decodable {
    let total: Int
    let page: Int
    let limit: Int
    let data: [Yeast]
}