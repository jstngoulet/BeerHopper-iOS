import DesignSystem
import SwiftUI

struct AppShellView: View {
    @ObservedObject
    private var router: AppRouter

    @ObservedObject
    private var sessionStore: AppSessionStore

    init(router: AppRouter, sessionStore: AppSessionStore) {
        self.router = router
        self.sessionStore = sessionStore
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
            ExploreRootView(currentRoute: self.router.currentRoute)

        case .search:
            SearchRootView(currentRoute: self.router.currentRoute)

        case .brew:
            BrewRootView(sessionState: self.sessionStore.state)

        case .community:
            CommunityRootView(currentRoute: self.router.currentRoute)

        case .profile:
            ProfileRootView(sessionStore: self.sessionStore)
        }
    }
}

#Preview {
    AppShellView(
        router: AppRouter(),
        sessionStore: AppSessionStore(initialState: .signedOut)
    )
}
