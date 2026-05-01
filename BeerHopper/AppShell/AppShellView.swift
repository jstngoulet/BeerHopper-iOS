import DesignSystem
import SwiftUI

struct AppShellView: View {
    @ObservedObject
    private var router: AppRouter

    @ObservedObject
    private var sessionStore: AppSessionStore

    private let discoveryRepository: DiscoveryRepository
    private let featureFlags: FeatureFlagProviding

    init(
        router: AppRouter,
        sessionStore: AppSessionStore,
        discoveryRepository: DiscoveryRepository = SeededDiscoveryRepository(),
        featureFlags: FeatureFlagProviding = FeatureFlagStore()
    ) {
        self.router = router
        self.sessionStore = sessionStore
        self.discoveryRepository = discoveryRepository
        self.featureFlags = featureFlags
    }

    var body: some View {
        TabView(selection: self.$router.selectedTab) {
            ForEach(BeerHopperTab.allCases) { tab in
                NavigationStack {
                    self.rootView(for: tab)
                        .navigationTitle(tab.title)
                        .toolbarTitleDisplayMode(.large)
                }
                .tag(tab)
                .tabItem {
                    Label(tab.title, systemImage: tab.systemImage)
                }
            }
        }
    }

    @ViewBuilder
    private func rootView(for tab: BeerHopperTab) -> some View {
        switch tab {
        case .explore:
            if self.featureFlags.isEnabled(.publicExploreFeed) {
                ExploreRootView(
                    currentRoute: self.router.currentRoute,
                    repository: self.discoveryRepository,
                    openProfile: {
                        self.router.route(to: .profile)
                    }
                )
            } else {
                self.featureUnavailableView(title: "Explore Preview", systemImage: "safari")
            }

        case .search:
            if self.featureFlags.isEnabled(.discoverySearch) {
                SearchRootView(
                    currentRoute: self.router.currentRoute,
                    repository: self.discoveryRepository,
                    openProfile: {
                        self.router.route(to: .profile)
                    }
                )
            } else {
                self.featureUnavailableView(title: "Search Preview", systemImage: "magnifyingglass")
            }

        case .brew:
            BrewRootView(sessionState: self.sessionStore.state)

        case .community:
            CommunityRootView(currentRoute: self.router.currentRoute)

        case .profile:
            ProfileRootView(sessionStore: self.sessionStore)
        }
    }

    private func featureUnavailableView(title: String, systemImage: String) -> some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            Text("This native flow is ready for validation and remains behind a disabled rollout flag.")
        }
        .background(BHColor.groupedBackground)
    }
}

#Preview {
    AppShellView(
        router: AppRouter(),
        sessionStore: AppSessionStore(initialState: .signedOut),
        discoveryRepository: SeededDiscoveryRepository(),
        featureFlags: FeatureFlagStore(flags: [.discoverySearch, .publicExploreFeed])
    )
}
