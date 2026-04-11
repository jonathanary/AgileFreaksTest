import SwiftUI

struct NowShowingSection: View {
    let movies: [Media]
    let isLoading: Bool
    let loadError: String?
    let onRetry: () -> Void
    let onMovieTap: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Now Showing")

            if let loadError, movies.isEmpty, !isLoading {
                sectionErrorView(message: loadError, onRetry: onRetry)
            } else if isLoading && movies.isEmpty {
                nowShowingSkeleton
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(movies) { movie in
                            Button {
                                onMovieTap(movie.id)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    PosterCard(
                                        imageURL: movie.coverImage?.extraLarge ?? movie.coverImage?.large
                                    )

                                    Text(movie.displayTitle)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 150, alignment: .leading)

                                    RatingBadge(score: movie.scoreOutOfTen)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    private var nowShowingSkeleton: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 150, height: 220)
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

struct SectionHeader: View {
    let title: String
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.accentColor)

            Spacer()

            if action != nil {
                Button("See more") {
                    action?()
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .overlay(
                    Capsule()
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal)
    }
}
