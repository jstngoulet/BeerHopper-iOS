import Foundation
import Security

struct AuthTokens: Equatable {
    let accessToken: String
    let refreshToken: String?
    let expiresAt: Date?
}

protocol TokenVault: AuthTokenProviding {
    func save(_ tokens: AuthTokens) async throws
    func load() async throws -> AuthTokens?
    func clear() async throws
}

actor KeychainTokenVault: TokenVault {
    private let service: String
    private let account: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        service: String = "com.beerhopper.ios.tokens",
        account: String = "session",
        encoder: JSONEncoder = BeerHopperJSON.encoder,
        decoder: JSONDecoder = BeerHopperJSON.decoder
    ) {
        self.service = service
        self.account = account
        self.encoder = encoder
        self.decoder = decoder
    }

    func currentAccessToken() async throws -> String? {
        return try await self.load()?.accessToken
    }

    func save(_ tokens: AuthTokens) async throws {
        let data = try self.encoder.encode(TokenPayload(tokens: tokens))
        let query = self.baseQuery()
        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecSuccess {
            return
        }

        if status != errSecItemNotFound {
            throw KeychainError(status: status)
        }

        var addQuery = query
        for attribute in attributes {
            addQuery[attribute.key] = attribute.value
        }

        let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
        guard addStatus == errSecSuccess else {
            throw KeychainError(status: addStatus)
        }
    }

    func load() async throws -> AuthTokens? {
        var query = self.baseQuery()
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError(status: status)
        }

        guard let data = result as? Data else {
            return nil
        }

        return try self.decoder.decode(TokenPayload.self, from: data).tokens
    }

    func clear() async throws {
        let status = SecItemDelete(self.baseQuery() as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError(status: status)
        }
    }

    private func baseQuery() -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.service,
            kSecAttrAccount as String: self.account
        ]
    }
}

struct KeychainError: Error, Equatable {
    let status: OSStatus
}

private struct TokenPayload: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresAt: Date?

    init(tokens: AuthTokens) {
        self.accessToken = tokens.accessToken
        self.refreshToken = tokens.refreshToken
        self.expiresAt = tokens.expiresAt
    }

    var tokens: AuthTokens {
        return AuthTokens(
            accessToken: self.accessToken,
            refreshToken: self.refreshToken,
            expiresAt: self.expiresAt
        )
    }
}

actor InMemoryTokenVault: TokenVault {
    private var tokens: AuthTokens?

    init(tokens: AuthTokens? = nil) {
        self.tokens = tokens
    }

    func currentAccessToken() async throws -> String? {
        return self.tokens?.accessToken
    }

    func save(_ tokens: AuthTokens) async throws {
        self.tokens = tokens
    }

    func load() async throws -> AuthTokens? {
        return self.tokens
    }

    func clear() async throws {
        self.tokens = nil
    }
}
