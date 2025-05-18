//
//  RESTClient.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

class RESTClient: NSObject {
    
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
    
    enum RESTError: LocalizedError {
        case invalidURL(String)
        case noDataReturned
        case unableToDecodeJSON
        case requestNotCreated
        case other(String)
    }
    
    private(set) static var currentENV: Host = .development
    
    private static var headers: [String: String] = [
        "API-Token": "b79cb3ba-745e-5d9a-8903-4a02327a7e09"   //  Token only valid locally
    ]
    
    //  Keep track of the current token
    public struct Token: Codable {
        let idToken: String?
        let refreshToken: String?
        let expiresIn: Int?
        
        var isExpired: Bool {
            guard let expiresIn, idToken != nil
            else { return true }
            
            //  Date logic should be based on date, not variable expires in
            //  For now, jsut return false
            return false
        }
        
        public init(from loginResult: LoginResult) {
            idToken = loginResult.idToken
            refreshToken = loginResult.refreshToken
            expiresIn = loginResult.expiresIn
        }
    }
    
    private static var idToken: String? {
        didSet {
            if let idToken {
                headers["Authorization"] = "Bearer \(idToken)"
            } else {
                headers.removeValue(forKey: "Authorization")
            }
        }
    }
    
    private static var token: Token? {
        didSet {
            idToken = token?.idToken
        }
    }
    
    /// The user is logged in if their token is not empty and not yet expired
    static var isLoggedIn: Bool
    { token != nil }
    
    class func set(token: Token?) {
        RESTClient.token = token
    }
    
    @discardableResult
    class func perform(
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
