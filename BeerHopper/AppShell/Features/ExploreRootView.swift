import DesignSystem
import SwiftUI

struct ExploreRootView: View {
    private let currentRoute: AppRoute?

    init(currentRoute: AppRoute?) {
        self.currentRoute = currentRoute
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
            VStack(spacing: BHSpacing.medium) {
                BHEntityRow(
                    title: "Nearby breweries",
                    subtitle: "Location-aware discovery will connect to the API in Sprint 4.",
                    metadata: "Soon",
                    systemImage: "mappin.and.ellipse"
                )
                BHEntityRow(
                    title: self.routeTitle,
                    subtitle: "Deep links land in the matching native tab and preserve route context.",
                    metadata: nil,
                    systemImage: "link"
                )
            }
            .padding(BHSpacing.large)
            .bhSurface()
        } inspector: {
            BHMetricTile(title: "Compatibility", value: "iOS", unit: "26+", systemImage: "iphone")
        }
        .background(BHColor.groupedBackground)
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
