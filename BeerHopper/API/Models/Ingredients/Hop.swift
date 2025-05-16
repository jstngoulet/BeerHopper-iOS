//
//  Hop.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//


struct Hop: Codable {
    let id: String
    let dateUpdated: String
    let name: String
    let alphaAcid: Double
    let betaAcid: Double
    let form: String
    let type: String
    let dateAdded: String
    let lastUpdated: String
    let imageUrl: String?
    let origin: String
    let myrcene: String
    let cohumulone: String
    let totalOil: String
    let flavorDescriptors: [String]
    let beerStyles: [String]
    let notes: String
}