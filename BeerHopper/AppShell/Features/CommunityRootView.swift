import DesignSystem
import SwiftUI

struct CommunityRootView: View {
    private let currentRoute: AppRoute?

    init(currentRoute: AppRoute?) {
        self.currentRoute = currentRoute
    }

    var body: some View {
        List {
            Section("Forums") {
                BHEntityRow(
                    title: self.postTitle,
                    subtitle: "Threaded discussion will connect after API/data layers are rebuilt.",
                    metadata: "Read-only",
                    systemImage: "text.bubble"
                )
            }
        }
    }

    private var postTitle: String {
        if case .forumPost(let id) = self.currentRoute {
            return "Post \(id)"
        }

        return "Latest discussions"
    }
}
