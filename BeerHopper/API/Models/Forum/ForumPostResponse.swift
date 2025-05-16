//
//  ForumPostResponse.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

// MARK: - Root Response
struct ForumPostResponse: Codable {
    let success: Bool
    let pageInfo: PageInfo
    let data: [ForumPost]
}
