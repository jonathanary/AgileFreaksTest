import SwiftUI

struct SectionErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: Design.Spacing.md) {
            Text(message)
                .font(.merriweather(.subheadline))
                .foregroundStyle(Color.secondaryLabel)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Retry", action: onRetry)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Design.Spacing.xxl)
        .padding(.horizontal)
    }
}
