import DesignSystem
import SwiftUI

struct MutationSignInPromptView: View {
    private let title: String
    private let message: String
    private let actionTitle: String
    private let signIn: () -> Void

    init(
        title: String = "Sign in required",
        message: String = "Public browsing is read-only. Sign in to save, follow, claim, or manage BeerHopper content.",
        actionTitle: String = "Go to Profile",
        signIn: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.signIn = signIn
    }

    var body: some View {
        VStack(alignment: .leading, spacing: BHSpacing.medium) {
            Label(self.title, systemImage: "lock")
                .font(.headline)

            Text(self.message)
                .font(.subheadline)
                .foregroundStyle(BHColor.textSecondary)

            Button(self.actionTitle, action: self.signIn)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(BHSpacing.large)
        .bhSurface()
    }
}
