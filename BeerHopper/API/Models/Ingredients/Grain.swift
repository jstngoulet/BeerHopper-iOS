//
//  Grain.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


struct Grain: Codable {
    let id: String
    let dateUpdated: String
    let name: String
    let lovibond: Double
    let potentialSG: Double
    let type: String
    let origin: String
    let imageUrl: String?
    let usage: String
    let flavorDescriptors: [String]
    let commonBeerStyles: [String]
    let notes: String
    let dateAdded: String
    let lastUpdated: String
}