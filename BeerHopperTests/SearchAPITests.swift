//
//  SearchAPITests.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import XCTest
@testable import BeerHopper

final class SearchAPITests: BeerHopperTests {
    
    let env: RESTClient.Host = .development
    let validQuery = "citra"
    let emptyQuery = ""
    let nonsenseQuery = "asdfghjklzxcvbnmqwerty"
    let specialCharQuery = "@#%&*()_+"
    let numericQuery = "123"
    let longQuery = String(repeating: "a", count: 1000)
    
    // MARK: - Valid Search Should Return Structured Data
    func test_performGeneralSearch_validQuery_returnsResults() async throws {
        let result = try await SearchAPI.performGeneralSearch(
            with: validQuery,
            types: [.hops, .grains, .yeasts],
            env: env
        )
        
        XCTAssertNotNil(result.hops)
        XCTAssertNotNil(result.grains)
        XCTAssertNotNil(result.yeasts)
        XCTAssertNil(result.posts)
        
        XCTAssertGreaterThanOrEqual(result.hops?.data.count ?? -1, 0)
        XCTAssertGreaterThanOrEqual(result.grains?.data.count ?? -1, 0)
        XCTAssertGreaterThanOrEqual(result.yeasts?.data.count ?? -1, 0)
        XCTAssertTrue(result.posts?.data == nil)
    }
    
    
    func test_performGeneralSearch_yeastsOnly_returnsResults() async throws {
        let result = try await SearchAPI.performGeneralSearch(
            with: validQuery,
            types: [.yeasts],
            env: env
        )
        
        XCTAssertNil(result.hops)
        XCTAssertNil(result.grains)
        XCTAssertNotNil(result.yeasts)
        XCTAssertNil(result.posts)
        
        XCTAssertGreaterThanOrEqual(result.yeasts?.data.count ?? -1, 0)
        XCTAssertTrue(result.hops?.data == nil)
        XCTAssertTrue(result.grains?.data == nil)
        XCTAssertTrue(result.posts?.data == nil)
    }
    
    // MARK: - Empty Query Should Fail
    func test_performGeneralSearch_emptyQuery_throwsError() async throws {
        do {
            _ = try await SearchAPI.performGeneralSearch(with: emptyQuery, env: env)
            XCTFail("Expected error for empty query, but succeeded")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    // MARK: - Nonsense Query Should Return Empty Results
    func test_performGeneralSearch_nonsenseQuery_returnsEmptyResults() async throws {
        let result = try await SearchAPI.performGeneralSearch(with: nonsenseQuery, env: env)
        
        XCTAssertEqual(result.hops?.data.count ?? -1, 0)
        XCTAssertEqual(result.grains?.data.count ?? -1, 0)
        XCTAssertEqual(result.yeasts?.data.count ?? -1, 0)
//        XCTAssertEqual(result.posts?.data.count ?? -1, 0)
    }
    
    // MARK: - Special Characters Query Should Not Crash
    func test_performGeneralSearch_specialCharactersQuery_safeHandling() async throws {
        let result = try await SearchAPI.performGeneralSearch(with: specialCharQuery, env: env)
        
        XCTAssertNotNil(result)
    }
    
    // MARK: - Numeric Query Should Not Crash
    func test_performGeneralSearch_numericQuery_safeHandling() async throws {
        let result = try await SearchAPI.performGeneralSearch(with: numericQuery, env: env)
        
        XCTAssertNotNil(result)
    }
    
    // MARK: - Long Query Should Be Handled
    func test_performGeneralSearch_longQuery_safeHandling() async throws {
        let result = try await SearchAPI.performGeneralSearch(with: longQuery, env: env)
        
        XCTAssertNotNil(result)
    }
    
    // MARK: - Invalid Host Should Throw
    func test_performGeneralSearch_invalidHost_throws() async throws {
        do {
            _ = try await SearchAPI.performGeneralSearch(with: validQuery, env: .custom("https://nonexistent.beerhopper.dev"))
            XCTFail("Expected error for invalid host")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    // MARK: - Decoder Fallback Should Work
    func test_performGeneralSearch_decoderHandlesFractionalDates() async throws {
        let result = try await SearchAPI.performGeneralSearch(with: validQuery, env: env)
        
        let sampleHop = result.hops?.data.first
        XCTAssertNotNil(sampleHop?.dateAdded)
    }
    
}
