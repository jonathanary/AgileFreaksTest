import SwiftUI

struct SectionHeaderRow: View {
    let title: String
    var showSeeMore: Bool = true

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.merriweatherFixed(size: Design.FontSize.sectionTitle, weight: .black))
                .foregroundStyle(Color.standardSectionTitle)
                .tracking(Design.FontSize.sectionTitle * Design.letterSpacingRatio)
                .lineSpacing(0)

            Spacer(minLength: Design.Spacing.sm)

            if showSeeMore {
                seeMoreButton
            }
        }
    }

    private var seeMoreButton: some View {
        Button {} label: {
            Text("See more")
                .font(.mulishFixed(size: Design.FontSize.seeMore, weight: .regular))
                .foregroundStyle(Color.secondaryLabel)
                .tracking(Design.FontSize.seeMore * Design.letterSpacingRatio)
                .lineSpacing(0)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal, Design.Spacing.md)
                .padding(.vertical, Design.Spacing.xxs + 1)
                .overlay(
                    Capsule()
                        .stroke(Color.secondaryLabel.opacity(0.45), lineWidth: 1)
                )
                .accessibilityHidden(true)
        }
    }
}

#Preview("Row") {
    SectionHeaderRow(title: "Now Showing")
        .padding(.horizontal)
}

#Preview("No see more") {
    SectionHeaderRow(title: "Cast", showSeeMore: false)
        .padding(.horizontal)
}
