import SwiftUI

struct PopularSection: View {
    let movies: [Movie]
    let isLoading: Bool
    let isLoadingMore: Bool
    let loadError: String?
    let onRetry: () -> Void
    let onLoadMore: () -> Void
    let onMovieTap: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.md) {
            SectionHeaderRow(title: "Popular")
                .padding(.horizontal)

            if let loadError, movies.isEmpty, !isLoading {
                SectionErrorView(message: loadError, onRetry: onRetry)
            } else if isLoading && movies.isEmpty {
                popularSkeleton
            } else {
                LazyVStack(spacing: Design.Spacing.lg) {
                    ForEach(movies) { movie in
                        Button {
                            onMovieTap(movie.id)
                        } label: {
                            PopularMovieRow(movie: movie)
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            if movie.id == movies.last?.id { onLoadMore() }
                        }
                    }

                    if isLoadingMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Design.Spacing.sm)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
    }

    private var popularSkeleton: some View {
        LazyVStack(spacing: Design.Spacing.lg) {
            ForEach(0..<3, id: \.self) { _ in
                HStack(spacing: Design.Skeleton.skeletonSpacing) {
                    SkeletonRect(
                        width: Design.Skeleton.popularPosterWidth,
                        height: Design.Skeleton.popularPosterHeight,
                        showSpinner: true
                    )
                    VStack(alignment: .leading, spacing: Design.Spacing.sm) {
                        SkeletonRect(
                            width: nil,
                            height: Design.Skeleton.popularTextHeight,
                            cornerRadius: Design.Skeleton.textCornerRadius,
                            color: .skeletonLight
                        )
                        SkeletonRect(
                            width: Design.Skeleton.popularPosterWidth,
                            height: Design.Skeleton.subtitleHeight,
                            cornerRadius: Design.Skeleton.textCornerRadius,
                            color: .skeletonLight
                        )
                        HStack(spacing: Design.Spacing.xs) {
                            ForEach(0..<2, id: \.self) { _ in
                                SkeletonRect(
                                    width: Design.Skeleton.genreTagWidth,
                                    height: Design.Skeleton.genreTagHeight,
                                    cornerRadius: Design.Skeleton.genreTagRadius,
                                    color: .skeletonLighter
                                )
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
}

private struct PopularMovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .top, spacing: Design.Spacing.lg) {
            PosterCard(
                imageURL: movie.coverImageURL,
                width: Design.PosterSize.popularWidth,
                height: Design.PosterSize.popularHeight
            )

            VStack(alignment: .leading, spacing: Design.Spacing.sm) {
                Text(movie.displayTitle)
                    .font(.mulishFixed(size: Design.FontSize.body, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                RatingBadge(score: movie.score)

                if !movie.genres.isEmpty {
                    HStack(spacing: Design.Spacing.xs) {
                        ForEach(movie.genres.prefix(3), id: \.self) { genre in
                            GenreTag(title: genre)
                        }
                    }
                }

                if movie.duration != "N/A" {
                    HStack(spacing: Design.Spacing.xxs) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundStyle(Color.black)
                        Text(movie.duration)
                            .font(.mulishFixed(size: Design.FontSize.caption, weight: .regular))
                            .foregroundStyle(Color.black)
                    }
                }
            }

            Spacer(minLength: 0)
        }
    }
}

#Preview("Loaded") {
    PopularSection(
        movies: Movie.mockList,
        isLoading: false, isLoadingMore: false, loadError: nil,
        onRetry: {}, onLoadMore: {}, onMovieTap: { _ in }
    )
}

#Preview("Loading") {
    PopularSection(
        movies: [], isLoading: true, isLoadingMore: false, loadError: nil,
        onRetry: {}, onLoadMore: {}, onMovieTap: { _ in }
    )
}

#Preview("Error") {
    PopularSection(
        movies: [], isLoading: false, isLoadingMore: false,
        loadError: "Could not load popular titles.",
        onRetry: {}, onLoadMore: {}, onMovieTap: { _ in }
    )
}

#Preview("Popular row") {
    PopularMovieRow(movie: Movie.mockList[0])
        .padding()
}
