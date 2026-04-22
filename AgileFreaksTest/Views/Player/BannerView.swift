import SwiftUI

struct AdBanner: View {
    let ad: Ad
    let remaining: TimeInterval
    let onSeeMore: () -> Void

    private var timerText: String {
        let total = max(0, Int(ceil(remaining)))
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.md) {
            HStack(alignment: .center, spacing: Design.Spacing.xxs) {
                Text(ad.bannerTitle)
                    .font(.mulishFixed(size: Design.FontSize.body, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if ad.detailURL != nil {
                    Button(action: onSeeMore) {
                        Text(ad.bannerCTATitle)
                            .font(.mulishFixed(size: Design.FontSize.body, weight: .bold))
                            .foregroundStyle(.black)
                            .padding(.horizontal, Design.Spacing.lg)
                            .padding(.vertical, Design.Spacing.sm)
                            .background(Capsule().fill(Color.white))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(ad.bannerCTATitle)
                    .clipShape(RoundedRectangle(cornerRadius: Design.CornerRadius.medium))
                }
            }

            Text("Ad • \(timerText)")
                .font(.mulishFixed(size: Design.FontSize.body, weight: .bold))
                .foregroundStyle(.white)
                .monospacedDigit()
        }
        .padding(Design.Spacing.lg)
        .frame(maxWidth: 360, alignment: .leading)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: Design.CornerRadius.medium))
    }
}

#Preview("AdBanner") {
    ZStack {
        Color.gray
        AdBanner(
            ad: .dunkinMock,
            remaining: 15,
            onSeeMore: {}
        )
    }
}
