@testable import BeerHopper
import XCTest

final class APIClientTests: XCTestCase {
    func testBuildsAuthenticatedJSONRequest() async throws {
        let transport = CapturingTransport(
            data: #"{"name":"Pike"}"#.data(using: .utf8) ?? Data(),
            statusCode: 200
        )
        let tokenVault = InMemoryTokenVault(
            tokens: AuthTokens(accessToken: "access-token", refreshToken: nil, expiresAt: nil)
        )
        let client = APIClient(
            baseURL: try XCTUnwrap(URL(string: "https://api.beerhopper.com/api")),
            transport: transport,
            tokenProvider: tokenVault
        )

        let response: BreweryDTO = try await client.send(
            APIRequest(path: "/breweries/123", queryItems: [URLQueryItem(name: "include", value: "stats")])
        )

        let request = try await transport.lastRequest()
        XCTAssertEqual(response.name, "Pike")
        XCTAssertEqual(request.url?.absoluteString, "https://api.beerhopper.com/api/breweries/123?include=stats")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer access-token")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
    }

    func testMapsHTTPStatusToAPIError() async throws {
        let transport = CapturingTransport(
            data: Data("rate limit".utf8),
            statusCode: 429,
            headers: ["Retry-After": "30"]
        )
        let client = APIClient(
            baseURL: try XCTUnwrap(URL(string: "https://api.beerhopper.com/api")),
            transport: transport,
            tokenProvider: InMemoryTokenVault()
        )

        do {
            let _: BreweryDTO = try await client.send(APIRequest(path: "/breweries/123"))
            XCTFail("Expected APIError.rateLimited")
        } catch let error as APIError {
            XCTAssertEqual(error, .rateLimited(retryAfter: 30))
        }
    }
}

private struct BreweryDTO: Decodable, Equatable {
    let name: String
}

private actor CapturingTransport: HTTPTransport {
    private let data: Data
    private let statusCode: Int
    private let headers: [String: String]
    private var request: URLRequest?

    init(data: Data, statusCode: Int, headers: [String: String] = [:]) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.request = request
        let response = HTTPURLResponse(
            url: request.url ?? URL(fileURLWithPath: "/"),
            statusCode: self.statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: self.headers
        ) ?? HTTPURLResponse()

        return (self.data, response)
    }

    func lastRequest() throws -> URLRequest {
        return try XCTUnwrap(self.request)
    }
}
