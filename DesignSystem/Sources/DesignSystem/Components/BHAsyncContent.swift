import SwiftUI

public enum BHAsyncState<Value> {
    case idle
    case loading
    case loaded(Value)
    case empty
    case failed(String)
}

public struct BHAsyncContent<Value, Content: View>: View {
    private let state: BHAsyncState<Value>
    private let retry: (() -> Void)?
    private let content: (Value) -> Content

    public init(
        state: BHAsyncState<Value>,
        retry: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.state = state
        self.retry = retry
        self.content = content
    }

    public var body: some View {
        switch self.state {
        case .idle:
            Label("Ready", systemImage: "hourglass")
                .frame(maxWidth: .infinity, minHeight: 120)

        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, minHeight: 120)

        case .loaded(let value):
            self.content(value)

        case .empty:
            Label("Nothing here yet", systemImage: "tray")
                .frame(maxWidth: .infinity, minHeight: 120)

        case .failed(let message):
            VStack(spacing: BHSpacing.medium) {
                Label("Unable to Load", systemImage: "exclamationmark.triangle")
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(BHColor.textSecondary)

                if let retry = self.retry {
                    Button("Retry", action: retry)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120)
        }
    }
}
