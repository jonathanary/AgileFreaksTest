import Foundation

private struct PaginationState {
    var currentPage = 0
    var hasNextPage = true
    var isLoadingMore = false
}

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

    private var nowShowingPagination = PaginationState()
    private var popularPagination = PaginationState()

    var isLoadingMoreNowShowing: Bool { nowShowingPagination.isLoadingMore }
    var isLoadingMorePopular: Bool { popularPagination.isLoadingMore }

    private let client = GraphQLClient.shared

    init() {
        isLoadingNowShowing = true
        isLoadingPopular = true
    }

    func loadMovies() async {
        Log.debug("HomeViewModel.loadMovies started", category: .home)
        errorMessage = nil
        nowShowingError = nil
        popularError = nil
        isLoadingNowShowing = true
        isLoadingPopular = true
        nowShowingPagination = PaginationState()
        popularPagination = PaginationState()

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

        Log.debug(
            "HomeViewModel.loadMovies finished (nowShowing: \(nowShowingMovies.count), popular: \(popularMovies.count))",
            category: .home
        )
    }

    func loadMoreNowShowing() async {
        guard !nowShowingPagination.isLoadingMore, nowShowingPagination.hasNextPage else { return }
        nowShowingPagination.isLoadingMore = true
        let nextPage = nowShowingPagination.currentPage + 1
        let result = await fetchMovies(query: GraphQLQueries.nowShowingMovies, page: nextPage)
        if result.error == nil {
            appendUniqueMedia(&nowShowingMovies, result.movies)
            applyPageInfo(&nowShowingPagination, result.pageInfo, requestedPage: nextPage)
        }
        nowShowingPagination.isLoadingMore = false
        Log.debug(
            "Now Showing load more page \(nextPage) (\(result.movies.count) items, hasNext: \(nowShowingPagination.hasNextPage))",
            category: .home
        )
    }

    func loadMorePopular() async {
        guard !popularPagination.isLoadingMore, popularPagination.hasNextPage else { return }
        popularPagination.isLoadingMore = true
        let nextPage = popularPagination.currentPage + 1
        let result = await fetchMovies(query: GraphQLQueries.popularMovies, page: nextPage)
        if result.error == nil {
            appendUniqueMedia(&popularMovies, result.movies)
            applyPageInfo(&popularPagination, result.pageInfo, requestedPage: nextPage)
        }
        popularPagination.isLoadingMore = false
        Log.debug(
            "Popular load more page \(nextPage) (\(result.movies.count) items, hasNext: \(popularPagination.hasNextPage))",
            category: .home
        )
    }

    private func loadNowShowingSection() async {
        let result = await fetchMovies(query: GraphQLQueries.nowShowingMovies, page: 1)
        nowShowingMovies = result.movies
        isLoadingNowShowing = false
        nowShowingError = result.error
        if result.error == nil {
            applyPageInfo(&nowShowingPagination, result.pageInfo, requestedPage: 1)
        } else {
            nowShowingPagination.hasNextPage = false
        }
        let status = result.error == nil ? "success" : "failed"
        Log.debug("Now Showing load \(status) (\(result.movies.count) items)", category: .home)
    }

    private func loadPopularSection() async {
        let result = await fetchMovies(query: GraphQLQueries.popularMovies, page: 1)
        popularMovies = result.movies
        isLoadingPopular = false
        popularError = result.error
        if result.error == nil {
            applyPageInfo(&popularPagination, result.pageInfo, requestedPage: 1)
        } else {
            popularPagination.hasNextPage = false
        }
        let status = result.error == nil ? "success" : "failed"
        Log.debug("Popular load \(status) (\(result.movies.count) items)", category: .home)
    }

    private func fetchMovies(query: String, page: Int) async -> (movies: [Media], pageInfo: PageInfo?, error: String?) {
        do {
            let variables: [String: Any] = ["page": page, "perPage": 10]
            let data: PageData = try await client.execute(
                query: query,
                variables: variables
            )
            return (data.Page.media ?? [], data.Page.pageInfo, nil)
        } catch {
            return ([], nil, error.localizedDescription)
        }
    }

    private func applyPageInfo(_ state: inout PaginationState, _ pageInfo: PageInfo?, requestedPage: Int) {
        if let pageInfo {
            state.currentPage = pageInfo.currentPage ?? requestedPage
            state.hasNextPage = pageInfo.hasNextPage ?? false
        } else {
            state.currentPage = requestedPage
            state.hasNextPage = false
        }
    }

    private func appendUniqueMedia(_ array: inout [Media], _ newItems: [Media]) {
        let existing = Set(array.map(\.id))
        let unique = newItems.filter { !existing.contains($0.id) }
        array.append(contentsOf: unique)
    }
}
