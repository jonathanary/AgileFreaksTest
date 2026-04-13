import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var didMarkHomeAppearance = false
    @Environment(Router.self) private var router

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .zero) {
                if viewModel.shouldShowFullScreenError, let message = viewModel.errorMessage {
                    errorView(message: message)
                } else {
                    NowShowingSection(
                        movies: viewModel.nowShowingMovies,
                        isLoading: viewModel.isLoadingNowShowing,
                        isLoadingMore: viewModel.isLoadingMoreNowShowing,
                        loadError: viewModel.nowShowingError,
                        onRetry: { Task { await viewModel.loadMovies() } },
                        onLoadMore: { Task { await viewModel.loadMoreNowShowing() } },
                        onMovieTap: { router.navigate(to: .detail(mediaId: $0)) }
                    )
                    .padding(.top, Design.Spacing.lg)

                    PopularSection(
                        movies: viewModel.popularMovies,
                        isLoading: viewModel.isLoadingPopular,
                        isLoadingMore: viewModel.isLoadingMorePopular,
                        loadError: viewModel.popularError,
                        onRetry: { Task { await viewModel.loadMovies() } },
                        onLoadMore: { Task { await viewModel.loadMorePopular() } },
                        onMovieTap: { router.navigate(to: .detail(mediaId: $0)) }
                    )
                    .padding(.top, Design.Spacing.xxl)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("LaunchLogo")
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {} label: {
                    Image("menu")
                        .foregroundStyle(Color.accentColor)
                }
                .accessibilityLabel("Menu")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image("notif")
                        .foregroundStyle(Color.accentColor)
                }
                .accessibilityLabel("Notifications")
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
        VStack(spacing: Design.Spacing.lg) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(Color.secondaryLabel)
            Text(message)
                .font(.merriweather(.subheadline))
                .foregroundStyle(Color.secondaryLabel)
                .multilineTextAlignment(.center)
            Button("Retry") {
                Task { await viewModel.loadMovies() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300)
    }
}

private struct HomeViewPreviewContainer: View {
    @State private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .detail(let mediaId):
                        DetailView(mediaId: mediaId)
                    }
                }
        }
        .environment(router)
        .environment(\.font, Font.merriweather(.body))
    }
}

#Preview {
    HomeViewPreviewContainer()
}
