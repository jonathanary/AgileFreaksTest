import SwiftUI

struct AdBanner: View {
    let ad: Ad
    let remaining: TimeInterval
    let onSeeMore: () -> Void

    private var secondsRemaining: Int {
        max(1, Int(ceil(remaining)))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.sm) {
            Text(ad.name)
                .font(.merriweather(.title3, weight: .bold))
                .foregroundStyle(.white)

            Text("\(secondsRemaining)s")
                .font(.merriweather(.body, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))
                .monospacedDigit()

            if ad.detailURL != nil {
                Button(action: onSeeMore) {
                    Text("See More")
                        .font(.merriweather(.callout, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.horizontal, Design.Spacing.lg)
                        .padding(.vertical, Design.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: Design.CornerRadius.small)
                                .fill(Color.white)
                        )
                }
                .accessibilityLabel("See More")
            }
        }
        .padding(Design.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Design.CornerRadius.medium)
                .fill(Color.black.opacity(0.65))
        )
        .fixedSize(horizontal: true, vertical: true)
    }
}
