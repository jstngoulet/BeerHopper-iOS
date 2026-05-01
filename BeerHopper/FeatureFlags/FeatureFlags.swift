import Foundation

struct FeatureFlag: Hashable, RawRepresentable, ExpressibleByStringLiteral {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    init(stringLiteral value: String) {
        self.rawValue = value
    }
}

struct ServerCapability: Hashable, RawRepresentable, ExpressibleByStringLiteral {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    init(stringLiteral value: String) {
        self.rawValue = value
    }
}

protocol FeatureFlagProviding {
    func isEnabled(_ flag: FeatureFlag) -> Bool
    func hasCapability(_ capability: ServerCapability) -> Bool
}

struct FeatureFlagStore: FeatureFlagProviding {
    private let flags: Set<FeatureFlag>
    private let capabilities: Set<ServerCapability>

    init(
        flags: Set<FeatureFlag> = [],
        capabilities: Set<ServerCapability> = []
    ) {
        self.flags = flags
        self.capabilities = capabilities
    }

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        return self.flags.contains(flag)
    }

    func hasCapability(_ capability: ServerCapability) -> Bool {
        return self.capabilities.contains(capability)
    }
}

extension FeatureFlag {
    static let discoverySearch: FeatureFlag = "discovery.search"
    static let publicExploreFeed: FeatureFlag = "explore.publicFeed"
}

extension ServerCapability {
    static let publicDiscovery: ServerCapability = "public.discovery"
    static let authenticatedMutations: ServerCapability = "auth.mutations"
}
