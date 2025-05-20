//
//  GrainResponse.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//

struct GrainResponse: Codable {
    
    let success: Bool
    let grain: Grain?
    let message: String?
    
}
