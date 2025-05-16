//
//  Post.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


struct Post: Codable {
    let id: String
    let dateUpdated: String
    let title: String
    let content: String
    let dateCreated: String
    let commentCount: Int
    let netLikes: Int
}
