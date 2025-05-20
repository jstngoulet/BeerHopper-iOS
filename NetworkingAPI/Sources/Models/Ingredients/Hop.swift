//
//  Hop.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

public
struct Hop: Codable, Sendable {
    public let id: String
    public let dateUpdated: String
    public let name: String
    public let alphaAcid: Double
    public let betaAcid: Double
    public let form: String
    public let type: String
    public let dateAdded: String
    public let lastUpdated: String
    public let imageUrl: String?
    public let origin: String
    public let myrcene: String
    public let cohumulone: String
    public let totalOil: String
    public let flavorDescriptors: [String]
    public let beerStyles: [String]
    public let notes: String
}
