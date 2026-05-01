import DesignSystem
import SwiftUI

struct EntityDetailView: View {
    @StateObject
    private var viewModel: EntityDetailViewModel

    private let openProfile: () -> Void

    init(
        repository: DiscoveryRepository,
        id: String,
        kind: DiscoveryEntityKind,
        openProfile: @escaping () -> Void
    ) {
        self._viewModel = StateObject(
            wrappedValue: EntityDetailViewModel(repository: repository, id: id, kind: kind)
        )
        self.openProfile = openProfile
    }

    var body: some View {
        ScrollView {
            BHAsyncContent(state: self.viewModel.state) { detail in
                BHColumnarLayout {
                    VStack(alignment: .leading, spacing: BHSpacing.medium) {
                        Label(detail.kind.singularTitle, systemImage: detail.kind.systemImage)
                            .font(.subheadline)
                            .foregroundStyle(BHColor.textSecondary)

                        Text(detail.title)
                            .font(.largeTitle.bold())

                        Text(detail.subtitle)
                            .font(.body)
                            .foregroundStyle(BHColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } secondary: {
                    VStack(alignment: .leading, spacing: BHSpacing.large) {
                        Text(detail.summary)
                            .font(.body)

                        MutationSignInPromptView(signIn: self.openProfile)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } inspector: {
                    BHMetricTile(
                        title: detail.primaryMetricTitle,
                        value: detail.primaryMetricValue,
                        unit: detail.primaryMetricUnit,
                        systemImage: detail.kind.systemImage
                    )
                }
            }
            .padding(BHSpacing.large)
        }
        .background(BHColor.groupedBackground)
        .navigationTitle("Details")
        .toolbarTitleDisplayMode(.inline)
        .task {
            await self.viewModel.load()
        }
    }
}
