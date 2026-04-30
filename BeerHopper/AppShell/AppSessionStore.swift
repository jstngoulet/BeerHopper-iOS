import Combine
import Foundation

enum AppSessionState: Equatable {
    case signedOut
    case signedIn(displayName: String)

    var isSignedIn: Bool {
        switch self {
        case .signedOut:
            return false

        case .signedIn:
            return true
        }
    }
}

@MainActor
final class AppSessionStore: ObservableObject {
    @Published
    private(set) var state: AppSessionState

    init(initialState: AppSessionState) {
        self.state = initialState
    }

    func markSignedOut() {
        self.state = .signedOut
    }

    func markSignedIn(displayName: String) {
        self.state = .signedIn(displayName: displayName)
    }
}
