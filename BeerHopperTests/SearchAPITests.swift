//
//  SearchAPITests.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import XCTest
@testable import BeerHopper

final class SearchAPITests: BeerHopperTests {
    
    func test_generalSearch() async throws {
        do {
            let searchResults = try await SearchAPI.performGeneralSearch(
                with: "a"
                , env: .development
            )
            XCTAssertNotNil(searchResults)
        } catch {
            throw error
        }
    }
    
}
