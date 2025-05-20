//
//  ForumComment.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import Foundation

// MARK: - Forum Comment
public
struct ForumComment: Codable, Identifiable, Sendable {
    public let id: String
    public let content: String
    public let dateCreated: String
    public let dateUpdated: String
    public let createdBy: ForumUser
}
