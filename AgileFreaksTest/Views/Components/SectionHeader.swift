import SwiftUI

/// Section title (Merriweather 900, 16pt, `Color.standardSectionTitle`).
struct SectionHeader: View {
    let title: String

    private static let titleSize: CGFloat = 21

    var body: some View {
        Text(title)
            .font(.merriweatherFixed(size: Self.titleSize, weight: .black))
            .foregroundStyle(Color.standardSectionTitle)
            .tracking(Self.titleSize * 0.02)
            .lineSpacing(0)
    }
}

/// Decorative “See more” capsule (no action). Mulish 400, 10pt, 2% tracking, `Color.secondaryLabel`.
struct SectionSeeMoreButton: View {
    private static let fontSize: CGFloat = 10

    var body: some View {
        Button (action: {}) {
            Text("See more")
                .font(.mulishFixed(size: Self.fontSize, weight: .regular))
                .foregroundStyle(Color.secondaryLabel)
                .tracking(Self.fontSize * 0.02)
                .lineSpacing(0)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .overlay(
                    Capsule()
                        .stroke(Color.secondaryLabel.opacity(0.45), lineWidth: 1)
                )
                .accessibilityHidden(true)
        }
    }
}

#Preview("Row") {
    HStack(alignment: .center) {
        SectionHeader(title: "Now Showing")
        Spacer(minLength: 8)
        SectionSeeMoreButton()
    }
    .padding(.horizontal)
}
