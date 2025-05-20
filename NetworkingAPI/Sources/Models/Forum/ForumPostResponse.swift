//
//  ForumPostResponse.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

// MARK: - Root Response
public
struct ForumPostResponse: Codable, Sendable {
    public let success: Bool
    public let pageInfo: PageInfo
    public let data: [ForumPost]
}
