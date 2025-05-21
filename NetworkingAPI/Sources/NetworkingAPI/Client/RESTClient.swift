//
//  RESTClient.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation
import Models

public
actor RESTClient: NSObject {
    
    public
    enum Host {
        case development
        case staging
        case production
        case custom(String)
        
        var baseURL: String {
            switch self {
            case .development:
                return "http://localhost:3030"
            case .staging:
                return "https://beerhopper-api.onrender.com"
            case .production:
                return "https://beerhopper-api.prod.onrender.com"
            case .custom(let url):
                return url
            }
        }
    }
    
    enum APIVersion: String {
        case v1 = "v1"
    }
    
    public
    enum RESTError: LocalizedError {
        case invalidURL(String)
        case noDataReturned
        case unableToDecodeJSON
        case requestNotCreated
        case other(String)
        
        public
        var errorDescription: String? {
            switch self {
            case .invalidURL(let url):
                return "Invalid URL: \(url)"
            case .noDataReturned:
                return "No data returned from server"
            case .unableToDecodeJSON:
                return "Unable to decode JSON from server"
            case .requestNotCreated:
                return "Unable to create URLRequest"
            case .other(let message):
                return message
            }
        }
    }
    
    public
    private(set) static var currentENV: Host = .development
    
    static var sharedDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601WithFractionalAndFallback
        return decoder
    }()
    
    private static var headers: [String: String] = [
        "API-Token": "b79cb3ba-745e-5d9a-8903-4a02327a7e09"   //  Token only valid locally
    ]
    
    private static var idToken: String? {
        didSet {
            if let idToken {
                headers["Authorization"] = "Bearer \(idToken)"
            } else {
                headers.removeValue(forKey: "Authorization")
            }
        }
    }
    
    /// The user is logged in if their token is not empty and not yet expired
    @MainActor
    public
    static var isLoggedIn: Bool
    {
        if idToken != nil { return true }
        if let token = TokenStore.retrieveToken(withKey: "id_token") {
            set(token: token)
            return true
        } else { return false }
    }
    
    static func set(token: Token?) {
        idToken = token?.idToken
    }
    
    @discardableResult
    static func perform(
        _ request: Request,
        env: Host = currentENV
    ) async throws -> Data? {
        
        //  Create the URL Request
        guard let url = URL(
            string: [
                env.baseURL,
                request.path
            ].joined()
        ) else { throw RESTError.invalidURL(request.classForCoder.description()) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        headers.forEach { item in
            urlRequest.setValue(item.value, forHTTPHeaderField: item.key)
        }
        
        //  Set the content type
        urlRequest.setValue(
            request.contentType.rawValue,
            forHTTPHeaderField: "Content-Type"
        )
        
        //  Set the body, if it exists
        if let body = request.body {
            urlRequest.httpBody = try JSONSerialization.data(
                withJSONObject: body
            )
        }
        
        //  Return the data
        return try await URLSession.shared.data(
            for: urlRequest
        ).0
    }
}
