//
//  Grain.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

struct Grain: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let lovibond: Double
    let potentialSG: Double
    let type: String
    let origin: String
    let imageUrl: String?
    let usage: String
    let flavorDescriptors: [String]
    let commonBeerStyles: [String]
    let substitutes: [Grain]?
    let notes: String
    let dateAdded: Date
    let lastUpdated: Date
}
