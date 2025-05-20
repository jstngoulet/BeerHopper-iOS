//
//  Post.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

// MARK: - Forum Post
public
struct ForumPost: Codable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let content: String
    public let dateCreated: Date
    public let createdBy: ForumUser?
    public let likes: Int
    public let dislikes: Int
    public let userReaction: UserPostReaction?
    public let comments: [ForumComment]?
    
    public var netLikes: Int { likes - dislikes }
    public var commentsCount: Int { comments?.count ?? 0 }
    
    public init(
        id: String,
        title: String,
        content: String,
        dateCreated: Date,
        createdBy: ForumUser?,
        likes: Int,
        dislikes: Int,
        userReaction: UserPostReaction?,
        comments: [ForumComment]?
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.dateCreated = dateCreated
        self.createdBy = createdBy
        self.likes = likes
        self.dislikes = dislikes
        self.userReaction = userReaction
        self.comments = comments
    }
}

public
enum UserPostReaction: String, Codable, Sendable {
    case like       = "LIKE"
    case dislike    = "DISLIKE"
}

