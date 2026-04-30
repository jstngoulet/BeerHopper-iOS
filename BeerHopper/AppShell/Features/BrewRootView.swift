import DesignSystem
import SwiftUI

struct BrewRootView: View {
    private let sessionState: AppSessionState

    init(sessionState: AppSessionState) {
        self.sessionState = sessionState
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BHSpacing.large) {
                if self.sessionState.isSignedIn {
                    self.signedInContent
                } else {
                    ContentUnavailableView {
                        Label("Sign in to Brew", systemImage: "lock")
                    } description: {
                        Text("Brew-day sessions, recipes, and measurements require an authenticated session.")
                    }
                }
            }
            .padding(BHSpacing.large)
        }
        .background(BHColor.groupedBackground)
    }

    private var signedInContent: some View {
        VStack(alignment: .leading, spacing: BHSpacing.large) {
            BHStatusBadge("Ready", systemImage: "checkmark.circle", tint: BHColor.success)
            BHMetricTile(title: "Batch", value: "0", unit: "active", systemImage: "drop")
        }
    }
}
