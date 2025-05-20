//
//  PageInfo.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//


// MARK: - Pagination
public
struct PageInfo: Codable, Sendable {
    public let page: Int
    public let limit: Int
    public let totalPages: Int
    public let totalPosts: Int
}
