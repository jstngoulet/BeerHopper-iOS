import DesignSystem
import SwiftUI

struct ProfileRootView: View {
    @ObservedObject
    private var sessionStore: AppSessionStore

    init(sessionStore: AppSessionStore) {
        self.sessionStore = sessionStore
    }

    var body: some View {
        Form {
            Section("Session") {
                switch self.sessionStore.state {
                case .signedOut:
                    ContentUnavailableView {
                        Label("Signed Out", systemImage: "person.crop.circle.badge.exclamationmark")
                    } description: {
                        Text("Authentication will be rebuilt behind injected API and secure-storage dependencies.")
                    } actions: {
                        Button("Sign in later") {}
                            .disabled(true)
                    }

                case .signedIn(let displayName):
                    LabeledContent("Signed in", value: displayName)
                    Button("Sign out") {
                        self.sessionStore.markSignedOut()
                    }
                }
            }

            Section("Privacy") {
                LabeledContent("Public mode", value: "Read-only")
                LabeledContent("Secrets", value: "Keychain required")
            }
        }
    }
}
