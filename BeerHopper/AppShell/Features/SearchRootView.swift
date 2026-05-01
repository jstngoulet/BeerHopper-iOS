import DesignSystem
import SwiftUI

struct SearchRootView: View {
    @StateObject
    private var viewModel: SearchViewModel

    private let repository: DiscoveryRepository
    private let openProfile: () -> Void

    init(
        currentRoute: AppRoute?,
        repository: DiscoveryRepository,
        openProfile: @escaping () -> Void
    ) {
        let initialQuery: String

        if case .search(let query) = currentRoute {
            initialQuery = query ?? ""
        } else {
            initialQuery = ""
        }

        self._viewModel = StateObject(
            wrappedValue: SearchViewModel(repository: repository, initialQuery: initialQuery)
        )
        self.repository = repository
        self.openProfile = openProfile
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("Scope", selection: self.$viewModel.scope) {
                ForEach(SearchScope.allCases) { scope in
                    Text(scope.title)
                        .tag(scope)
                }
            }
            .pickerStyle(.segmented)
            .padding([.horizontal, .top], BHSpacing.large)
            .onChange(of: self.viewModel.scope) { _, newValue in
                self.viewModel.selectScope(newValue)
            }

            BHAsyncContent(state: self.viewModel.state) { results in
                List {
                    Section("Results") {
                        ForEach(results) { result in
                            NavigationLink {
                                EntityDetailView(
                                    repository: self.repository,
                                    id: result.id,
                                    kind: result.kind,
                                    openProfile: self.openProfile
                                )
                            } label: {
                                BHEntityRow(
                                    title: result.title,
                                    subtitle: result.subtitle,
                                    metadata: result.metadata,
                                    systemImage: result.kind.systemImage
                                )
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(BHColor.groupedBackground)
        .searchable(text: self.$viewModel.query, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            self.viewModel.submitSearch()
        }
        .task {
            await self.viewModel.search()
        }
    }
}
