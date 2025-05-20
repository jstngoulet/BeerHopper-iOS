//
//  ForumUser.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//


// MARK: - User
public
struct ForumUser: Codable, Identifiable, Sendable {
    public let id: String
    public let username: String
    
    public
    init(id: String, username: String) {
        self.id = id
        self.username = username
    }
}
