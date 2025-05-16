//
//  Yeast.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


struct Yeast: Codable {
    let id: String
    let dateUpdated: String
    let dateAdded: String
    let lastUpdated: String
    let name: String
    let type: String
    let form: String
    let attenuation: Double
    let flocculation: Double
    let origin: String
    let alcoholTolerance: String
    let temperatureRange: String
    let notes: String
    let imageUrl: String?
    let flavorProfile: [String]
    let beerStyles: [String]
}