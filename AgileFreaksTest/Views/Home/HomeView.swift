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
            VStack(alignment: .leading, spacing: .zero) {
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
                    .padding(.top, 16)
                    .border(.red)

                    PopularSection(
                        movies: viewModel.popularMovies,
                        isLoading: viewModel.isLoadingPopular,
                        loadError: viewModel.popularError,
                        onRetry: { Task { await viewModel.loadMovies() } },
                        onMovieTap: { mediaId in
                            router.navigate(to: .detail(mediaId: mediaId))
                        }
                    )
                    .padding(.top, 24)
                    .border(.blue)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("LaunchLogo")
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                } label: {
                    Image("menu")
                        .foregroundStyle(Color.accentColor)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Image("notif")
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
                .font(.merriweather(.subheadline))
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
