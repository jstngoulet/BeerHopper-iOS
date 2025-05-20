//
//  IngredientsAPI.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//
import Foundation
import Models

public
final class IngredientsAPI: NSObject {
    
    public
    class func fetchGrain(
        withID grainID: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> Grain {
        do {
            guard let response = try await RESTClient.perform(
                FetchGrainRequest(
                    grainId: grainID
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            let grainResponse = try RESTClient.sharedDecoder.decode(
                GrainResponse.self,
                from: response
            )
            
            guard let grain = grainResponse.grain
                    , grainResponse.success
            else {
                throw RESTClient.RESTError.other(
                    grainResponse.message ?? "Grain not found"
                )
            }
            
            return grain
            
        } catch {
            throw error
        }
    }
    
}
