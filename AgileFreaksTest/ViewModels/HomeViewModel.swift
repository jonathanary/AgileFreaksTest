import Foundation

/// Loads home feed from AniList. All state updates happen on the main actor for safe SwiftUI observation.
@MainActor
@Observable
final class HomeViewModel {
    private(set) var nowShowingMovies: [Media] = []
    private(set) var popularMovies: [Media] = []

    /// Per-section loading so the first completed request can render without waiting for the other.
    private(set) var isLoadingNowShowing = true
    private(set) var isLoadingPopular = true

    /// Per-section errors (e.g. one request succeeds while the other fails).
    private(set) var nowShowingError: String?
    private(set) var popularError: String?

    /// Set when both sections fail so the home screen can offer a single retry affordance.
    private(set) var errorMessage: String?

    private let client = GraphQLClient.shared

    init() {
        isLoadingNowShowing = true
        isLoadingPopular = true
    }

    func loadMovies() async {
        errorMessage = nil
        nowShowingError = nil
        popularError = nil
        isLoadingNowShowing = true
        isLoadingPopular = true

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadNowShowingSection() }
            group.addTask { await self.loadPopularSection() }
        }

        if nowShowingMovies.isEmpty, popularMovies.isEmpty {
            if let e1 = nowShowingError, let e2 = popularError, e1 != e2 {
                errorMessage = "\(e1)\n\(e2)"
            } else {
                errorMessage = nowShowingError ?? popularError
            }
        } else {
            errorMessage = nil
        }
    }

    private func loadNowShowingSection() async {
        let result = await fetchMovies(query: GraphQLQueries.nowShowingMovies)
        nowShowingMovies = result.movies
        isLoadingNowShowing = false
        nowShowingError = result.error
    }

    private func loadPopularSection() async {
        let result = await fetchMovies(query: GraphQLQueries.popularMovies)
        popularMovies = result.movies
        isLoadingPopular = false
        popularError = result.error
    }

    private func fetchMovies(query: String) async -> (movies: [Media], error: String?) {
        do {
            let variables: [String: Any] = ["page": 1, "perPage": 10]
            let data: PageData = try await client.execute(
                query: query,
                variables: variables
            )
            return (data.Page.media ?? [], nil)
        } catch {
            return ([], error.localizedDescription)
        }
    }
}
