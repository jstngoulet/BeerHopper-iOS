//
//  Yeast.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

public
struct Yeast: Codable, Sendable, Identifiable {
    public let id: String
    public let dateUpdated: Date
    public let dateAdded: Date
    public let lastUpdated: Date
    public let name: String
    public let type: String
    public let form: String
    public let attenuation: Double
    public let flocculation: Int
    public let origin: String
    public let alcoholTolerance: String
    public let temperatureRange: String
    public let notes: String
    public let imageUrl: String?
    public let flavorProfile: [String]
    public let beerStyles: [String]
}
