import SwiftUI

struct DetailView: View {
    let mediaId: Int
    private static let playTrailerFontSize: CGFloat = 12
    private static let titleFontSize: CGFloat = 20
    private static let descriptionFontSize: CGFloat = 16
    private static let descriptionBodyFontSize: CGFloat = 12
    private var loadOnAppear: Bool
    @State private var viewModel: DetailViewModel
    @Environment(Router.self) private var router
    @Environment(\.openURL) private var openURL

    init(mediaId: Int) {
        self.mediaId = mediaId
        loadOnAppear = true
        _viewModel = State(initialValue: DetailViewModel())
    }

    /// Previews with `Media.mockDetail` without refetching.
    init(previewViewModel: DetailViewModel) {
        mediaId = previewViewModel.media?.id ?? 1
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
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(Color.secondaryLabel)
                    Text(error)
                        .font(.merriweather(.subheadline))
                        .foregroundStyle(Color.secondaryLabel)
                    Button("Retry") {
                        Task { await viewModel.loadDetail(id: mediaId) }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let media = viewModel.media {
                content(for: media)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(8)
                        .background(Circle().fill(.black.opacity(0.3)))
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(8)
                        .background(Circle().fill(.black.opacity(0.3)))
                }
            }
        }
        .task {
            if loadOnAppear {
                await viewModel.loadDetail(id: mediaId)
            }
        }
    }

    private func content(for media: Media) -> some View {
        ScrollView {
            VStack(spacing: .zero) {
                heroBanner(for: media)

                VStack(alignment: .leading, spacing: 20) {
                    movieInfo(for: media)

                    if !media.cleanDescription.isEmpty {
                        descriptionSection(for: media)
                    }

                    CastSection(characters: media.characters)
                }
                .padding(.horizontal)
                .padding(.top, 24)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 24,
                        topTrailingRadius: 24
                    )
                )
                .offset(y: -24)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(.systemBackground))
    }

    private func heroBanner(for media: Media) -> some View {
        ZStack {
            let bannerURL = media.bannerImage ?? media.coverImage?.extraLarge
            AsyncImage(url: URL(string: bannerURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                @unknown default:
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                }
            }
            .containerRelativeFrame(.horizontal)
            .frame(height: 300)
            .clipped()
            .overlay {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }

            if let trailerURL = media.trailer?.url {
                Button {
                    openURL(trailerURL)
                } label: {
                    VStack(spacing: 4) {
                        Image("playButton")
                            .font(.system(size: 45))
                            .foregroundStyle(.white)

                        Text("Play Trailer")
                            .font(.mulishFixed(size: Self.playTrailerFontSize, weight: .bold))
                            .foregroundStyle(Color.white)
                            .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func movieInfo(for media: Media) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(alignment: .top) {
                Text(media.displayTitle)
                    .font(.mulishFixed(size: Self.titleFontSize, weight: .bold))

                Spacer()

                Button {} label: {
                    Image("tab3")
                        .font(.body)
                        .foregroundStyle(Color.black)
                }
            }
            .padding(.bottom, 8)

            RatingBadge(score: media.scoreOutOfTen)
                .padding(.bottom, 16)

            if let genres = media.genres, !genres.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(genres, id: \.self) { genre in
                            GenreTag(title: genre)
                        }
                    }
                }
                .padding(.bottom, 16)
            }

            HStack(alignment: .top, spacing: 0) {
                InfoColumn(title: "Length", value: media.formattedDuration)
                InfoColumn(title: "Language", value: media.languageFromCountry)
                InfoColumn(title: "Rating", value: media.format ?? "N/A")
            }
            .padding(.vertical, 4)
        }
    }

    private func descriptionSection(for media: Media) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.merriweatherFixed(size: Self.descriptionFontSize, weight: .black))
                .foregroundStyle(Color.standardSectionTitle)
                .tracking(Self.descriptionFontSize * 0.02)
                .lineSpacing(0)

            Text(media.cleanDescription)
                .font(.mulishFixed(size: Self.descriptionBodyFontSize, weight: .semibold))
                .foregroundStyle(Color.tertiaryLabel)
                .tracking(Self.descriptionFontSize * 0.02)
                .lineSpacing(0)
        }
    }
}

private struct InfoColumn: View {
    let title: String
    let value: String
    private static let titleFontSize: CGFloat = 12
    private static let valueFontSize: CGFloat = 12

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.mulishFixed(size: Self.titleFontSize, weight: .regular))
                .foregroundStyle(Color.secondaryLabel)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(value)
                .font(.mulishFixed(size: Self.valueFontSize, weight: .semibold))
                .foregroundStyle(Color.black)
                .tracking(Self.valueFontSize * 0.02)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: 109, maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Loaded") {
    NavigationStack {
        DetailView(mediaId: 1)
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
