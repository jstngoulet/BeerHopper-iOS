//
//  Post.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

// MARK: - Forum Post
struct ForumPost: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let createdBy: ForumUser?
    let likes: Int
    let dislikes: Int
    let userReaction: UserPostReaction?
    let commentsCount: Int
    let comments: [ForumComment]?
    
    var netLikes: Int { likes - dislikes }
}

enum UserPostReaction: String, Codable {
    case like       = "LIKE"
    case dislike    = "DISLIKE"
}

