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
    let dateCreated: Date
    let createdBy: ForumUser?
    let likes: Int
    let dislikes: Int
    let userReaction: UserPostReaction?
    let comments: [ForumComment]?
    
    var netLikes: Int { likes - dislikes }
    var commentsCount: Int { comments?.count ?? 0 }
}

enum UserPostReaction: String, Codable {
    case like       = "LIKE"
    case dislike    = "DISLIKE"
}

