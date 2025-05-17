//
//  PaginatedHopResponse.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


struct PaginatedHopResponse: Codable {
    let total: Int
    let page: Int
    let limit: Int
    let data: [Hop]
    
    private struct RawData: Decodable {
        let total: Int
        let page: Int
        let limit: Int
        let data: [FailableDecodable<Hop>]
    }
    
    init(from decoder: Decoder) throws {
        let raw = try RawData(from: decoder)
        total = raw.total
        page = raw.page
        limit = raw.limit
        data = raw.data.compactMap { $0.value } // 🔥 filters out decoding failures
    }
}
