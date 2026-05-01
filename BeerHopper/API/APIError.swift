import Foundation

enum APIError: Error, Equatable {
    case invalidBaseURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case rateLimited(retryAfter: TimeInterval?)
    case server(statusCode: Int, message: String?)
    case decoding(String)
    case transport(String)

    init(statusCode: Int, message: String? = nil, retryAfter: TimeInterval? = nil) {
        switch statusCode {
        case 401:
            self = .unauthorized

        case 403:
            self = .forbidden

        case 404:
            self = .notFound

        case 429:
            self = .rateLimited(retryAfter: retryAfter)

        default:
            self = .server(statusCode: statusCode, message: message)
        }
    }
}
