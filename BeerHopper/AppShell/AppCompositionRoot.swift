import Combine
import Foundation

@MainActor
final class AppCompositionRoot: ObservableObject {
    let router: AppRouter
    let sessionStore: AppSessionStore
    let apiClient: APIClientProtocol
    let tokenVault: TokenVault
    let featureFlags: FeatureFlagProviding
    let discoveryRepository: DiscoveryRepository

    private let deepLinkParser: DeepLinkParsing

    init(
        router: AppRouter? = nil,
        sessionStore: AppSessionStore? = nil,
        configuration: AppConfiguration = .production,
        tokenVault: TokenVault = InMemoryTokenVault(),
        featureFlags: FeatureFlagProviding = FeatureFlagStore(),
        discoveryRepository: DiscoveryRepository? = nil,
        deepLinkParser: DeepLinkParsing = BeerHopperDeepLinkParser()
    ) {
        self.router = router ?? AppRouter()
        self.sessionStore = sessionStore ?? AppSessionStore(initialState: .signedOut)
        self.tokenVault = tokenVault
        self.featureFlags = featureFlags
        self.apiClient = APIClient(
            baseURL: configuration.apiBaseURL,
            tokenProvider: tokenVault
        )
        self.discoveryRepository = discoveryRepository ?? SeededDiscoveryRepository()
        self.deepLinkParser = deepLinkParser
    }

    func open(_ url: URL) {
        guard let route = self.deepLinkParser.parse(url) else {
            return
        }

        self.router.route(to: route)
    }
}
