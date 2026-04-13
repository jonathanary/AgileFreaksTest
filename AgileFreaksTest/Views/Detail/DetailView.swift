import SwiftUI

struct DetailView: View {
    let mediaId: Int
    private var loadOnAppear: Bool
    @State private var viewModel: DetailViewModel
    @Environment(Router.self) private var router
    @Environment(\.openURL) private var openURL

    init(mediaId: Int) {
        self.mediaId = mediaId
        loadOnAppear = true
        _viewModel = State(initialValue: DetailViewModel())
    }

    init(previewViewModel: DetailViewModel) {
        mediaId = previewViewModel.movie?.id ?? 1
        loadOnAppear = false
        _viewModel = State(initialValue: previewViewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .font(.merriweather(.body))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                fullScreenError(error)
            } else if let movie = viewModel.movie {
                content(for: movie)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { router.pop() } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(Design.Spacing.sm)
                        .background(Circle().fill(Color.overlayDark))
                }
                .accessibilityLabel("Back")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(Design.Spacing.sm)
                        .background(Circle().fill(Color.overlayDark))
                }
                .accessibilityLabel("More options")
            }
        }
        .task {
            if loadOnAppear { await viewModel.loadDetail(id: mediaId) }
        }
    }

    // MARK: - Subviews

    private func fullScreenError(_ message: String) -> some View {
        VStack(spacing: Design.Spacing.lg) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(Color.secondaryLabel)
            Text(message)
                .font(.merriweather(.subheadline))
                .foregroundStyle(Color.secondaryLabel)
            Button("Retry") {
                Task { await viewModel.loadDetail(id: mediaId) }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func content(for movie: Movie) -> some View {
        ScrollView {
            VStack(spacing: .zero) {
                heroBanner(for: movie)

                VStack(alignment: .leading, spacing: Design.Spacing.xl) {
                    movieInfo(for: movie)

                    if !movie.description.isEmpty {
                        descriptionSection(for: movie)
                    }

                    CastSection(cast: movie.cast)
                }
                .padding(.horizontal)
                .padding(.top, Design.Spacing.xxl)
                .padding(.bottom, Design.Spacing.xl)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: Design.CornerRadius.large,
                        topTrailingRadius: Design.CornerRadius.large
                    )
                )
                .offset(y: -Design.Spacing.xxl)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(.systemBackground))
    }

    private func heroBanner(for movie: Movie) -> some View {
        ZStack {
            RemoteImage(
                url: (movie.bannerImageURL ?? movie.coverImageURL).flatMap { URL(string: $0) },
                placeholder: AnyView(Rectangle().fill(Color.bannerPlaceholder))
            )
            .containerRelativeFrame(.horizontal)
            .frame(height: Design.Banner.height)
            .clipped()
            .overlay {
                LinearGradient(
                    colors: [.clear, Color.overlayGradient],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }

            if let trailerURL = movie.trailerURL {
                Button {
                    openURL(trailerURL)
                } label: {
                    VStack(spacing: Design.Spacing.xxs) {
                        Image("playButton")
                            .font(.system(size: Design.Banner.playIconSize))
                            .foregroundStyle(.white)

                        Text("Play Trailer")
                            .font(.mulishFixed(size: Design.FontSize.caption, weight: .bold))
                            .foregroundStyle(.white)
                            .designShadow(Design.Shadows.playTrailer)
                    }
                }
                .accessibilityLabel("Play trailer")
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func movieInfo(for movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(alignment: .top) {
                Text(movie.displayTitle)
                    .font(.mulishFixed(size: Design.FontSize.movieTitle, weight: .bold))
                Spacer()
                Button {} label: {
                    Image("bookmark")
                        .font(.body)
                        .foregroundStyle(Color.black)
                }
                .accessibilityLabel("Bookmark")
            }
            .padding(.bottom, Design.Spacing.sm)

            RatingBadge(score: movie.score)
                .padding(.bottom, Design.Spacing.lg)

            if !movie.genres.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Design.Spacing.sm) {
                        ForEach(movie.genres, id: \.self) { genre in
                            GenreTag(title: genre)
                        }
                    }
                }
                .padding(.bottom, Design.Spacing.lg)
            }

            HStack(alignment: .top, spacing: 0) {
                InfoColumn(title: "Length", value: movie.duration)
                InfoColumn(title: "Language", value: movie.language)
                InfoColumn(title: "Rating", value: movie.format)
            }
            .padding(.vertical, Design.Spacing.xxs)
        }
    }

    private func descriptionSection(for movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: Design.Spacing.sm) {
            Text("Description")
                .font(.merriweatherFixed(size: Design.FontSize.sectionDescription, weight: .black))
                .foregroundStyle(Color.standardSectionTitle)
                .tracking(Design.FontSize.sectionDescription * Design.letterSpacingRatio)
                .lineSpacing(0)

            Text(movie.description)
                .font(.mulishFixed(size: Design.FontSize.caption, weight: .semibold))
                .foregroundStyle(Color.tertiaryLabel)
                .tracking(Design.FontSize.sectionDescription * Design.letterSpacingRatio)
                .lineSpacing(0)
        }
    }
}

private struct InfoColumn: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: Design.Spacing.xxs) {
            Text(title)
                .font(.mulishFixed(size: Design.FontSize.caption, weight: .regular))
                .foregroundStyle(Color.secondaryLabel)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(value)
                .font(.mulishFixed(size: Design.FontSize.caption, weight: .semibold))
                .foregroundStyle(Color.black)
                .tracking(Design.FontSize.caption * Design.letterSpacingRatio)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: Design.InfoColumn.minWidth, maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Loaded") {
    NavigationStack {
        DetailView(previewViewModel: .previewLoaded())
    }
    .environment(Router())
}

#Preview("Info columns") {
    HStack {
        InfoColumn(title: "Length", value: "2h 5m")
        InfoColumn(title: "Language", value: "Japanese")
        InfoColumn(title: "Rating", value: "Movie")
    }
    .padding()
}
