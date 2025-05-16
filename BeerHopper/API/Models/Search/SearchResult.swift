//
//  SearchResult.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


/**
 Decodable as we are just getting it from the server
 */
class SearchResult: Decodable {
    let hops: PaginatedHopResponse?
    let grains: PaginatedGrainResponse?
    let yeasts: PaginatedYeastResponse?
    let posts: PaginatedPostResponse?
}
