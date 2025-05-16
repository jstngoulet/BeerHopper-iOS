//
//  SearchAPI.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

final class SearchAPI: NSObject {

    class func performGeneralSearch(
        with query: String?,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> SearchResult {
        do {
            guard let responseData = try await RESTClient.perform(
                SearchRequest(query: query),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            let results = try JSONDecoder().decode(
                SearchResult.self,
                from: responseData
            )
            
            return results
        } catch {
            throw error
        }
    }
    
}
