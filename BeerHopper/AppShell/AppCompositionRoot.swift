import Combine
import Foundation

@MainActor
final class AppCompositionRoot: ObservableObject {
    let router: AppRouter
    let sessionStore: AppSessionStore

    private let deepLinkParser: DeepLinkParsing

    init(
        router: AppRouter? = nil,
        sessionStore: AppSessionStore? = nil,
        deepLinkParser: DeepLinkParsing = BeerHopperDeepLinkParser()
    ) {
        self.router = router ?? AppRouter()
        self.sessionStore = sessionStore ?? AppSessionStore(initialState: .signedOut)
        self.deepLinkParser = deepLinkParser
    }

    func open(_ url: URL) {
        guard let route = self.deepLinkParser.parse(url) else {
            return
        }

        self.router.route(to: route)
    }
}
