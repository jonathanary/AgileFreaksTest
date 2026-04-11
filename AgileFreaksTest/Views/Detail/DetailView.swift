import SwiftUI

struct DetailView: View {
    let mediaId: Int
    @State private var viewModel = DetailViewModel()
    @Environment(Router.self) private var router
    @Environment(\.openURL) private var openURL

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text(error)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
            await viewModel.loadDetail(id: mediaId)
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
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.white)
                        Text("Play Trailer")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func movieInfo(for media: Media) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Text(media.displayTitle)
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button {
                    viewModel.isBookmarked.toggle()
                } label: {
                    Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                }
            }

            RatingBadge(score: media.scoreOutOfTen)

            if let genres = media.genres, !genres.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(genres, id: \.self) { genre in
                            GenreTag(title: genre)
                        }
                    }
                }
            }

            HStack(spacing: 0) {
                InfoColumn(title: "Length", value: media.formattedDuration)
                Spacer()
                InfoColumn(title: "Language", value: media.languageFromCountry)
                Spacer()
                InfoColumn(title: "Rating", value: media.format ?? "N/A")
            }
            .padding(.vertical, 4)
        }
    }

    private func descriptionSection(for media: Media) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.accentColor)

            Text(media.cleanDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
    }
}

private struct InfoColumn: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}
