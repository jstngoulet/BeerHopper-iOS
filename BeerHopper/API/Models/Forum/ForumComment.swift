//
//  ForumComment.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import Foundation

// MARK: - Forum Comment
struct ForumComment: Codable, Identifiable {
    let id: String
    let content: String
    let dateCreated: String
    let dateUpdated: String
    let createdBy: ForumUser
}
