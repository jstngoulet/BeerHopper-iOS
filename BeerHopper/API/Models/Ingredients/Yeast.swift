//
//  Yeast.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

struct Yeast: Codable {
    let id: String
    let dateUpdated: Date
    let dateAdded: Date
    let lastUpdated: Date
    let name: String
    let type: String
    let form: String
    let attenuation: Double
    let flocculation: Int
    let origin: String
    let alcoholTolerance: String
    let temperatureRange: String
    let notes: String
    let imageUrl: String?
    let flavorProfile: [String]
    let beerStyles: [String]
}
