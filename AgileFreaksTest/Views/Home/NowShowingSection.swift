import SwiftUI

struct NowShowingSection: View {
    let movies: [Media]
    let isLoading: Bool
    let isLoadingMore: Bool
    let loadError: String?
    let onRetry: () -> Void
    let onLoadMore: () -> Void
    let onMovieTap: (Int) -> Void

    private static let movieTitleSize: CGFloat = 14
    /// Matches `PosterCard` width so wrapping uses a definite measure inside `ScrollView`/`LazyHStack`.
    private static let movieTitleWidth: CGFloat = 143

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(alignment: .center) {
                SectionHeader(title: "Now Showing")
                Spacer(minLength: 8)
                SectionSeeMoreButton()
            }
            .padding(.horizontal)

            if let loadError, movies.isEmpty, !isLoading {
                sectionErrorView(message: loadError, onRetry: onRetry)
            } else if isLoading && movies.isEmpty {
                nowShowingSkeleton
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(movies) { movie in
                            Button {
                                onMovieTap(movie.id)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    PosterCard(
                                        imageURL: movie.coverImage?.large ?? movie.coverImage?.extraLarge
                                    )

                                    Text(movie.displayTitle)
                                        .font(.mulishFixed(size: Self.movieTitleSize, weight: .bold))
                                        .foregroundStyle(Color.black)
                                        .tracking(Self.movieTitleSize * 0.02)
                                        .lineSpacing(0)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: Self.movieTitleWidth, alignment: .topLeading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    if !movie.scoreOutOfTen.isEmpty {
                                        RatingBadge(score: movie.scoreOutOfTen)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                if movie.id == movies.last?.id {
                                    onLoadMore()
                                }
                            }
                        }

                        if isLoadingMore {
                            ProgressView()
                                .frame(width: 48, height: 212)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 16)
            }
        }
    }

    private var nowShowingSkeleton: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(0..<4, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 143, height: 212)
                            .overlay {
                                ProgressView()
                            }

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.15))
                            .frame(width: 120, height: 14)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.15))
                            .frame(width: 80, height: 12)
                    }
                }
            }
            .padding(.horizontal)
        }
        .accessibilityLabel("Loading Now Showing")
    }

    private func sectionErrorView(message: String, onRetry: @escaping () -> Void) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .font(.merriweather(.subheadline))
                .foregroundStyle(Color.secondaryLabel)
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

#Preview("Loaded") {
    NowShowingSection(
        movies: Media.mockList,
        isLoading: false,
        isLoadingMore: false,
        loadError: nil,
        onRetry: {},
        onLoadMore: {},
        onMovieTap: { _ in }
    )
}

#Preview("Loading more") {
    NowShowingSection(
        movies: Media.mockList,
        isLoading: false,
        isLoadingMore: true,
        loadError: nil,
        onRetry: {},
        onLoadMore: {},
        onMovieTap: { _ in }
    )
}

#Preview("Loading") {
    NowShowingSection(
        movies: [],
        isLoading: true,
        isLoadingMore: false,
        loadError: nil,
        onRetry: {},
        onLoadMore: {},
        onMovieTap: { _ in }
    )
}

#Preview("Error") {
    NowShowingSection(
        movies: [],
        isLoading: false,
        isLoadingMore: false,
        loadError: "Could not load movies.",
        onRetry: {},
        onLoadMore: {},
        onMovieTap: { _ in }
    )
}
