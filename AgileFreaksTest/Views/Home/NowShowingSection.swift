import SwiftUI

struct NowShowingSection: View {
    let movies: [Movie]
    let isLoading: Bool
    let isLoadingMore: Bool
    let loadError: String?
    let onRetry: () -> Void
    let onLoadMore: () -> Void
    let onMovieTap: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            SectionHeaderRow(title: "Now Showing")
                .padding(.horizontal)

            if let loadError, movies.isEmpty, !isLoading {
                SectionErrorView(message: loadError, onRetry: onRetry)
            } else if isLoading && movies.isEmpty {
                nowShowingSkeleton
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: Design.Spacing.lg) {
                        ForEach(movies) { movie in
                            Button {
                                onMovieTap(movie.id)
                            } label: {
                                VStack(alignment: .leading, spacing: Design.Spacing.sm) {
                                    PosterCard(imageURL: movie.coverImageURL)

                                    Text(movie.displayTitle)
                                        .font(.mulishFixed(size: Design.FontSize.body, weight: .bold))
                                        .foregroundStyle(Color.black)
                                        .tracking(Design.FontSize.body * Design.letterSpacingRatio)
                                        .lineSpacing(0)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: Design.PosterSize.nowShowingWidth, alignment: .topLeading)
                                        .fixedSize(horizontal: false, vertical: true)

                                    if !movie.score.isEmpty {
                                        RatingBadge(score: movie.score)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(movie.displayTitle), rated \(movie.score) out of 10")
                            .onAppear {
                                if movie.id == movies.last?.id { onLoadMore() }
                            }
                        }

                        if isLoadingMore {
                            ProgressView()
                                .frame(width: Design.Skeleton.loadMoreWidth, height: Design.PosterSize.nowShowingHeight)
                        }
                    }
                    .padding(.horizontal, Design.Spacing.lg)
                }
                .padding(.top, Design.Spacing.lg)
            }
        }
    }

    private var nowShowingSkeleton: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: Design.Spacing.lg) {
                ForEach(0..<4, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: Design.Spacing.sm) {
                        SkeletonRect(
                            width: Design.PosterSize.nowShowingWidth,
                            height: Design.PosterSize.nowShowingHeight,
                            showSpinner: true
                        )
                        SkeletonRect(
                            width: Design.Skeleton.titleWidth,
                            height: Design.Skeleton.titleHeight,
                            cornerRadius: Design.Skeleton.textCornerRadius,
                            color: .skeletonLight
                        )
                        SkeletonRect(
                            width: Design.Skeleton.subtitleWidth,
                            height: Design.Skeleton.subtitleHeight,
                            cornerRadius: Design.Skeleton.textCornerRadius,
                            color: .skeletonLight
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .accessibilityLabel("Loading Now Showing")
    }
}

#Preview("Loaded") {
    NowShowingSection(
        movies: Movie.mockList,
        isLoading: false, isLoadingMore: false, loadError: nil,
        onRetry: {}, onLoadMore: {}, onMovieTap: { _ in }
    )
}

#Preview("Loading") {
    NowShowingSection(
        movies: [], isLoading: true, isLoadingMore: false, loadError: nil,
        onRetry: {}, onLoadMore: {}, onMovieTap: { _ in }
    )
}

#Preview("Error") {
    NowShowingSection(
        movies: [], isLoading: false, isLoadingMore: false,
        loadError: "Could not load movies.",
        onRetry: {}, onLoadMore: {}, onMovieTap: { _ in }
    )
}
