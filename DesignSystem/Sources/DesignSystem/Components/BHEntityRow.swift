import SwiftUI

public struct BHEntityRow: View {
    private let title: String
    private let subtitle: String
    private let metadata: String?
    private let systemImage: String

    public init(
        title: String,
        subtitle: String,
        metadata: String? = nil,
        systemImage: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.metadata = metadata
        self.systemImage = systemImage
    }

    public var body: some View {
        HStack(spacing: BHSpacing.medium) {
            Image(systemName: self.systemImage)
                .font(.title3)
                .foregroundStyle(BHColor.action)
                .frame(width: 36, height: 36)
                .background(BHColor.action.opacity(0.12), in: RoundedRectangle(cornerRadius: BHRadius.compact))

            VStack(alignment: .leading, spacing: BHSpacing.xSmall) {
                Text(self.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(BHColor.textPrimary)

                Text(self.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(BHColor.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: BHSpacing.small)

            if let metadata = self.metadata {
                Text(metadata)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(BHColor.textSecondary)
            }
        }
        .padding(.vertical, BHSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}
