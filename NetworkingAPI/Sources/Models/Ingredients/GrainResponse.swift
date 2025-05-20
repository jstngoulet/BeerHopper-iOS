//
//  GrainResponse.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//

public
struct GrainResponse: Codable, Sendable {
    
    public let success: Bool
    public let grain: Grain?
    public let message: String?
    
}
