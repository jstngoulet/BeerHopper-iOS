//
//  Grain.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

public
struct Grain: Codable, Hashable, Identifiable, Sendable {
    public let id: String
    public let name: String
    public let lovibond: Double
    public let potentialSG: Double
    public let type: String
    public let origin: String
    public let imageUrl: String?
    public let usage: String
    public let flavorDescriptors: [String]
    public let commonBeerStyles: [String]
    public let substitutes: [Grain]?
    public let notes: String
    public let dateAdded: Date
    public let lastUpdated: Date
}
