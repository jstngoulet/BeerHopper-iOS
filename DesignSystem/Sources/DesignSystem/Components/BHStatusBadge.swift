import SwiftUI

public struct BHStatusBadge: View {
    private let title: String
    private let systemImage: String?
    private let tint: Color

    public init(
        _ title: String,
        systemImage: String? = nil,
        tint: Color = BHColor.action
    ) {
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
    }

    public var body: some View {
        Label {
            Text(self.title)
                .font(.caption.weight(.semibold))
        } icon: {
            if let systemImage = self.systemImage {
                Image(systemName: systemImage)
                    .imageScale(.small)
            }
        }
        .foregroundStyle(self.tint)
        .padding(.horizontal, BHSpacing.small)
        .padding(.vertical, BHSpacing.xSmall)
        .background(self.tint.opacity(0.12), in: Capsule())
        .accessibilityElement(children: .combine)
    }
}
