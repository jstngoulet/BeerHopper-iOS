//
//  PageInfo.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//


// MARK: - Pagination
struct PageInfo: Codable {
    let page: Int
    let limit: Int
    let totalPages: Int
    let totalPosts: Int
}