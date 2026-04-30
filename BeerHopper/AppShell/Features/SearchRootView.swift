import DesignSystem
import SwiftUI

struct SearchRootView: View {
    private let currentRoute: AppRoute?

    @State
    private var query: String

    init(currentRoute: AppRoute?) {
        self.currentRoute = currentRoute
        if case .search(let query) = currentRoute {
            self._query = State(initialValue: query ?? "")
        } else {
            self._query = State(initialValue: "")
        }
    }

    var body: some View {
        List {
            Section("Suggestions") {
                BHEntityRow(
                    title: "Breweries",
                    subtitle: "Search breweries by name, location, or style.",
                    systemImage: "building.2"
                )
                BHEntityRow(
                    title: "Recipes",
                    subtitle: "Search future recipe and ingredient results.",
                    systemImage: "book.pages"
                )
            }
        }
        .searchable(text: self.$query, placement: .navigationBarDrawer(displayMode: .always))
    }
}
