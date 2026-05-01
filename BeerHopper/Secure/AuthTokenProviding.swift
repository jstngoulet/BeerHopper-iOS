import Foundation

protocol AuthTokenProviding {
    func currentAccessToken() async throws -> String?
}
