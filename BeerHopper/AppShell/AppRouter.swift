import Combine
import Foundation

@MainActor
final class AppRouter: ObservableObject {
    @Published
    var selectedTab: BeerHopperTab

    @Published
    private(set) var currentRoute: AppRoute?

    init(selectedTab: BeerHopperTab = .explore) {
        self.selectedTab = selectedTab
        self.currentRoute = nil
    }

    func route(to route: AppRoute) {
        self.currentRoute = route
        self.selectedTab = route.preferredTab
    }

    func select(_ tab: BeerHopperTab) {
        self.selectedTab = tab
    }
}
