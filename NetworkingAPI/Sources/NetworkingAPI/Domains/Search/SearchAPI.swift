//
//  SearchAPI.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation
import Models

public
final class SearchAPI: NSObject {
    
    public
    class func performGeneralSearch(
        with query: String?,
        types: [SearchObjectType]? = nil,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> SearchResult {
        do {
            guard let responseData = try await RESTClient.perform(
                SearchRequest(
                    query: query,
                    types: types
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            let results = try RESTClient.sharedDecoder.decode(
                SearchResult.self,
                from: responseData
            )
            
            //  Return error
            if results.success == false
                , let message = results.message {
                throw RESTClient.RESTError.other(message)
            }
            
            return results
        } catch {
            throw error
        }
    }
    
}
