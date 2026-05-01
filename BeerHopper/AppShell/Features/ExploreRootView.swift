import DesignSystem
import SwiftUI

struct ExploreRootView: View {
    @StateObject
    private var viewModel: ExploreFeedViewModel

    private let currentRoute: AppRoute?
    private let repository: DiscoveryRepository
    private let openProfile: () -> Void

    init(
        currentRoute: AppRoute?,
        repository: DiscoveryRepository,
        openProfile: @escaping () -> Void
    ) {
        self.currentRoute = currentRoute
        self.repository = repository
        self.openProfile = openProfile
        self._viewModel = StateObject(wrappedValue: ExploreFeedViewModel(repository: repository))
    }

    var body: some View {
        BHColumnarLayout {
            VStack(alignment: .leading, spacing: BHSpacing.large) {
                BHStatusBadge("Public", systemImage: "eye", tint: BHColor.info)
                Text("Discover breweries, beers, recipes, and community activity.")
                    .font(.body)
                    .foregroundStyle(BHColor.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } secondary: {
            VStack(alignment: .leading, spacing: BHSpacing.medium) {
                BHAsyncContent(state: self.viewModel.state) { items in
                    VStack(spacing: BHSpacing.medium) {
                        ForEach(items) { item in
                            NavigationLink {
                                EntityDetailView(
                                    repository: self.repository,
                                    id: item.entityID,
                                    kind: item.kind,
                                    openProfile: self.openProfile
                                )
                            } label: {
                                BHEntityRow(
                                    title: item.title,
                                    subtitle: item.subtitle,
                                    metadata: item.metadata,
                                    systemImage: item.kind.systemImage
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        BHEntityRow(
                            title: self.routeTitle,
                            subtitle: "Deep links land in the matching native tab and preserve route context.",
                            metadata: nil,
                            systemImage: "link"
                        )
                    }
                }
            }
            .padding(BHSpacing.large)
            .bhSurface()
        } inspector: {
            MutationSignInPromptView(signIn: self.openProfile)
        }
        .background(BHColor.groupedBackground)
        .task {
            await self.viewModel.load()
        }
    }

    private var routeTitle: String {
        guard let currentRoute = self.currentRoute else {
            return "No active route"
        }

        switch currentRoute {
        case .brewery(let id):
            return "Brewery \(id)"

        case .brewerySlug(_, _, let slug):
            return slug

        default:
            return "Route received"
        }
    }
}
