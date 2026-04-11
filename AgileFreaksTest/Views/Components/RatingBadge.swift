import SwiftUI

struct RatingBadge: View {
    let score: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .font(.caption)
            Text("\(score)/10 IMDb")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    RatingBadge(score: "9.1")
}
