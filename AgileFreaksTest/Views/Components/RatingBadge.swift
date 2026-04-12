import SwiftUI

struct RatingBadge: View {
    let score: String
    private static let fontSize: CGFloat = 10

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .font(.caption)

            Text("\(score)/10 IMDb")
                .font(.mulishFixed(size: Self.fontSize, weight: .bold))
                .foregroundStyle(Color.secondaryLabel)
        }
    }
}

#Preview("High") {
    RatingBadge(score: "9.1")
}
