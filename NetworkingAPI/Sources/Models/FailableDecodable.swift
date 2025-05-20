//
//  FailableDecodable.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/16/25.
//

public
struct FailableDecodable<T: Codable & Sendable>: Codable, Sendable {
    let value: T?
    
    public
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
