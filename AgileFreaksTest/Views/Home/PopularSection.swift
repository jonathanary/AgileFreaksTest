import SwiftUI

struct PopularSection: View {
    let movies: [Media]
    let isLoading: Bool
    let loadError: String?
    let onRetry: () -> Void
    let onMovieTap: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Popular")

            if let loadError, movies.isEmpty, !isLoading {
                sectionErrorView(message: loadError, onRetry: onRetry)
            } else if isLoading && movies.isEmpty {
                popularSkeleton
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(movies) { movie in
                        Button {
                            onMovieTap(movie.id)
                        } label: {
                            PopularMovieRow(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var popularSkeleton: some View {
        LazyVStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { _ in
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 140)
                        .overlay {
                            ProgressView()
                        }

                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 18)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.15))
                            .frame(width: 100, height: 12)
                        HStack(spacing: 6) {
                            ForEach(0..<2, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.12))
                                    .frame(width: 56, height: 22)
                            }
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(.horizontal)
        .accessibilityLabel("Loading Popular")
    }

    private func sectionErrorView(message: String, onRetry: @escaping () -> Void) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Retry", action: onRetry)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal)
    }
}

private struct PopularMovieRow: View {
    let movie: Media

    var body: some View {
        HStack(spacing: 14) {
            PosterCard(
                imageURL: movie.coverImage?.large ?? movie.coverImage?.medium,
                width: 100,
                height: 140
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.displayTitle)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                RatingBadge(score: movie.scoreOutOfTen)

                if let genres = movie.genres, !genres.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(genres.prefix(3), id: \.self) { genre in
                            GenreTag(title: genre)
                        }
                    }
                }

                if movie.duration != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(movie.formattedDuration)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer(minLength: 0)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX - spacing)
        }

        return (positions, CGSize(width: maxX, height: currentY + lineHeight))
    }
}
