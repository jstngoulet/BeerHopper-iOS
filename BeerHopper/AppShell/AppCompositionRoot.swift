import Combine
import Foundation

@MainActor
final class AppCompositionRoot: ObservableObject {
    let router: AppRouter
    let sessionStore: AppSessionStore

    private let deepLinkParser: DeepLinkParsing

    init(
        router: AppRouter = AppRouter(),
        sessionStore: AppSessionStore = AppSessionStore(initialState: .signedOut),
        deepLinkParser: DeepLinkParsing = BeerHopperDeepLinkParser()
    ) {
        self.router = router
        self.sessionStore = sessionStore
        self.deepLinkParser = deepLinkParser
    }

    func open(_ url: URL) {
        guard let route = self.deepLinkParser.parse(url) else {
            return
        }

        self.router.route(to: route)
    }
}
