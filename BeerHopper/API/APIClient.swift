import Foundation

protocol APIClientProtocol {
    func send<Response: Decodable>(_ request: APIRequest<Response>) async throws -> Response
}

protocol HTTPTransport {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

struct URLSessionHTTPTransport: HTTPTransport {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.session.data(for: request)
    }
}

struct APIClient: APIClientProtocol {
    private let baseURL: URL
    private let transport: HTTPTransport
    private let tokenProvider: AuthTokenProviding
    private let decoder: JSONDecoder

    init(
        baseURL: URL,
        transport: HTTPTransport = URLSessionHTTPTransport(),
        tokenProvider: AuthTokenProviding,
        decoder: JSONDecoder = BeerHopperJSON.decoder
    ) {
        self.baseURL = baseURL
        self.transport = transport
        self.tokenProvider = tokenProvider
        self.decoder = decoder
    }

    func send<Response: Decodable>(_ request: APIRequest<Response>) async throws -> Response {
        let urlRequest = try await self.urlRequest(for: request)
        let payload: (Data, URLResponse)

        do {
            payload = try await self.transport.data(for: urlRequest)
        } catch {
            throw APIError.transport(error.localizedDescription)
        }

        guard let httpResponse = payload.1 as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError(
                statusCode: httpResponse.statusCode,
                message: self.errorMessage(from: payload.0),
                retryAfter: self.retryAfter(from: httpResponse)
            )
        }

        if Response.self == EmptyResponse.self {
            guard let empty = EmptyResponse() as? Response else {
                throw APIError.decoding("Unable to create empty response.")
            }

            return empty
        }

        do {
            return try self.decoder.decode(Response.self, from: payload.0)
        } catch {
            throw APIError.decoding(error.localizedDescription)
        }
    }

    private func urlRequest<Response: Decodable>(for request: APIRequest<Response>) async throws -> URLRequest {
        guard var components = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidBaseURL
        }

        components.path = self.normalizedPath(request.path)
        components.queryItems = request.queryItems.isEmpty ? nil : request.queryItems

        guard let url = components.url else {
            throw APIError.invalidBaseURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if request.body != nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if let token = try await self.tokenProvider.currentAccessToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        for header in request.headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }

        return urlRequest
    }

    private func normalizedPath(_ path: String) -> String {
        let basePath = self.baseURL.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let requestPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        if basePath.isEmpty {
            return "/\(requestPath)"
        }

        if requestPath.isEmpty {
            return "/\(basePath)"
        }

        return "/\(basePath)/\(requestPath)"
    }

    private func errorMessage(from data: Data) -> String? {
        guard !data.isEmpty else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    private func retryAfter(from response: HTTPURLResponse) -> TimeInterval? {
        guard let value = response.value(forHTTPHeaderField: "Retry-After") else {
            return nil
        }

        return TimeInterval(value)
    }
}
