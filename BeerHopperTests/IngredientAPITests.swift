//
//  IngredientAPITests.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//

import XCTest
@testable import BeerHopper

final class IngredientAPITests: BeerHopperTests {
    
    let env: RESTClient.Host = .development
    
    // MARK: - Success
    func test_fetchGrain_validID_returnsGrain() async throws {
        let validID = "0028237b-e11c-4129-8e56-91b7007405f9"
        let grain = try await IngredientsAPI.fetchGrain(withID: validID, env: env)
        
        XCTAssertEqual(grain.id, validID)
        XCTAssertFalse(grain.name.isEmpty)
        XCTAssertGreaterThan(grain.lovibond, 0)
        XCTAssertNotNil(grain.dateAdded)
    }
    
    // MARK: - Missing ID or Not Found
    func test_fetchGrain_invalidID_throws() async {
        let invalidID = "nonexistent-id"
        
        do {
            _ = try await IngredientsAPI.fetchGrain(withID: invalidID, env: env)
            XCTFail("Expected error for invalid grain ID")
        } catch let error as RESTClient.RESTError {
            switch error {
            case .other(let message):
                XCTAssertTrue(message.contains("not found") || !message.isEmpty)
            default:
                XCTFail("Unexpected RESTError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Invalid Host
    func test_fetchGrain_invalidHost_throws() async {
        do {
            _ = try await IngredientsAPI.fetchGrain(
                withID: "0028237b-e11c-4129-8e56-91b7007405f9",
                env: .custom("https://nonexistent.beerhopper.dev")
            )
            XCTFail("Expected error for invalid host")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    // MARK: - Decoder Handles Nested Substitutes
    func test_fetchGrain_withSubstitutes_decodesProperly() async throws {
        let grain = try await IngredientsAPI.fetchGrain(
            withID: "0028237b-e11c-4129-8e56-91b7007405f9",
            env: env
        )
        
        XCTAssertNotNil(grain.substitutes)
        XCTAssertFalse(grain.substitutes?.isEmpty ?? true)
        XCTAssertFalse(grain.substitutes?.first?.name.isEmpty ?? true)
        XCTAssertNotNil(grain.substitutes?.first?.dateAdded)
    }
    
    // MARK: - Fallback to default error message
    func test_fetchGrain_successFalse_messageFallback() async throws {
        // This assumes a mocked or staged endpoint where success=false and message is nil
        do {
            _ = try await IngredientsAPI.fetchGrain(
                withID: "grain-without-message",
                env: env
            )
            XCTFail("Expected fallback error")
        } catch let RESTClient.RESTError.other(message) {
            XCTAssertEqual(message, "Error fetching grain")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
