import SwiftUI

public struct BHColumnarLayout<Primary: View, Secondary: View, Inspector: View>: View {
    private let primary: Primary
    private let secondary: Secondary
    private let inspector: Inspector

    public init(
        @ViewBuilder primary: () -> Primary,
        @ViewBuilder secondary: () -> Secondary,
        @ViewBuilder inspector: () -> Inspector
    ) {
        self.primary = primary()
        self.secondary = secondary()
        self.inspector = inspector()
    }

    public var body: some View {
        GeometryReader { proxy in
            let sizeClass = BHColumnSizeClass(width: proxy.size.width)

            switch sizeClass {
            case .compact:
                ScrollView {
                    VStack(alignment: .leading, spacing: BHSpacing.large) {
                        self.primary
                        self.secondary
                        self.inspector
                    }
                    .padding(BHSpacing.large)
                }

            case .regular:
                HStack(alignment: .top, spacing: BHSpacing.large) {
                    self.primary
                        .frame(maxWidth: 280)
                    self.secondary
                }
                .padding(BHSpacing.large)

            case .expanded:
                HStack(alignment: .top, spacing: BHSpacing.large) {
                    self.primary
                        .frame(maxWidth: 280)
                    self.secondary
                    self.inspector
                        .frame(maxWidth: 260)
                }
                .padding(BHSpacing.large)
            }
        }
    }
}
