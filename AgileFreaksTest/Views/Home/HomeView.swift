import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var didMarkHomeAppearance = false
    @Environment(Router.self) private var router

    private var loadsAreComplete: Bool {
        !viewModel.isLoadingNowShowing && !viewModel.isLoadingPopular
    }

    private var shouldShowFullScreenError: Bool {
        loadsAreComplete
            && viewModel.nowShowingMovies.isEmpty
            && viewModel.popularMovies.isEmpty
            && viewModel.errorMessage != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if shouldShowFullScreenError, let message = viewModel.errorMessage {
                    errorView(message: message)
                } else {
                    NowShowingSection(
                        movies: viewModel.nowShowingMovies,
                        isLoading: viewModel.isLoadingNowShowing,
                        loadError: viewModel.nowShowingError,
                        onRetry: { Task { await viewModel.loadMovies() } },
                        onMovieTap: { mediaId in
                            router.navigate(to: .detail(mediaId: mediaId))
                        }
                    )

                    PopularSection(
                        movies: viewModel.popularMovies,
                        isLoading: viewModel.isLoadingPopular,
                        loadError: viewModel.popularError,
                        onRetry: { Task { await viewModel.loadMovies() } },
                        onMovieTap: { mediaId in
                            router.navigate(to: .detail(mediaId: mediaId))
                        }
                    )
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("FilmKu")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentColor)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundStyle(Color.accentColor)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "bell")
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
        .onAppear {
            guard !didMarkHomeAppearance else { return }
            didMarkHomeAppearance = true
            Log.debug("HomeView appeared", category: .home)
        }
        .task {
            if viewModel.nowShowingMovies.isEmpty, viewModel.popularMovies.isEmpty {
                Log.debug("HomeView requested initial home load", category: .home)
                await viewModel.loadMovies()
            }
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Retry") {
                Task {
                    await viewModel.loadMovies()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300)
    }
}
