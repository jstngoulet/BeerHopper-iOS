//
//  FailableDecodable.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/16/25.
//


struct FailableDecodable<T: Codable>: Codable {
    let value: T?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            value = try container.decode(T.self)
        } catch {
            print("⚠️ Failed to decode \(T.self):", error)
            value = nil
        }
    }
}
