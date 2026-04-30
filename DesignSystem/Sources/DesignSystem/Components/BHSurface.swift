import SwiftUI

public struct BHSurface: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: BHRadius.group, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: BHRadius.group, style: .continuous)
                    .stroke(BHColor.border.opacity(0.35), lineWidth: 0.5)
            }
    }
}

public extension View {
    func bhSurface() -> some View {
        return self.modifier(BHSurface())
    }
}
