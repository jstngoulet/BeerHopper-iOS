//
//  SearchResult.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


/**
 Decodable as we are just getting it from the server
 */
public
final class SearchResult: Codable, Sendable {
    public let success: Bool
    public let message: String?
    
    public let hops: PaginatedHopResponse?
    public let grains: PaginatedGrainResponse?
    public let yeasts: PaginatedYeastResponse?
    public let posts: PaginatedPostResponse?
}
