//
//  FetchGrainRequest.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//

class FetchGrainRequest: GETRequest {
    
    init(
        grainId: String
    ) {
        super.init(
            body: nil,
            path: "/api/grains/\(grainId)",
            contentType: .json
        )
    }
}
