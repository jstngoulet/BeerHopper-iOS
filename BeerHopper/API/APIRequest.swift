import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct APIRequest<Response: Decodable> {
    let method: HTTPMethod
    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Data?

    init(
        method: HTTPMethod = .get,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        responseType: Response.Type = Response.self
    ) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }
}

extension APIRequest where Response == EmptyResponse {
    init(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.init(
            method: method,
            path: path,
            queryItems: queryItems,
            headers: headers,
            body: body,
            responseType: EmptyResponse.self
        )
    }
}

struct EmptyResponse: Decodable, Equatable {}
