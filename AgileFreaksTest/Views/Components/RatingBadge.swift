import SwiftUI

struct RatingBadge: View {
    let score: String

    var body: some View {
        HStack(spacing: Design.Spacing.xxs) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .font(.caption)

            Text("\(score)/10 IMDb")
                .font(.mulishFixed(size: Design.FontSize.caption, weight: .regular))
                .foregroundStyle(Color.tertiaryLabel)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Rating \(score) out of 10 IMDb")
    }
}

#Preview("High") {
    RatingBadge(score: "9.1")
}
