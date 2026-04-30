import SwiftUI

public struct BHMetricTile: View {
    private let title: String
    private let value: String
    private let unit: String?
    private let systemImage: String

    public init(
        title: String,
        value: String,
        unit: String? = nil,
        systemImage: String
    ) {
        self.title = title
        self.value = value
        self.unit = unit
        self.systemImage = systemImage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: BHSpacing.small) {
            Label(self.title, systemImage: self.systemImage)
                .font(.caption)
                .foregroundStyle(BHColor.textSecondary)

            HStack(alignment: .firstTextBaseline, spacing: BHSpacing.xSmall) {
                Text(self.value)
                    .font(.title2.monospacedDigit().weight(.semibold))
                    .foregroundStyle(BHColor.textPrimary)

                if let unit = self.unit {
                    Text(unit)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(BHColor.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(BHSpacing.large)
        .modifier(BHSurface())
        .accessibilityElement(children: .combine)
    }
}
