//
//  PaginatedGrainResponse.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

public
struct PaginatedGrainResponse: Codable, Sendable {
    public let total: Int
    public let page: Int
    public let limit: Int
    public let data: [Grain]
    
    private struct RawData: Codable, Sendable {
        let total: Int
        let page: Int
        let limit: Int
        let data: [FailableDecodable<Grain>]
    }
    
    public
    init(from decoder: Decoder) throws {
        let raw = try RawData(from: decoder)
        total = raw.total
        page = raw.page
        limit = raw.limit
        data = raw.data.compactMap { $0.value } // 🔥 filters out decoding failures
    }
}

