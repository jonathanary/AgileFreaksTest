import Foundation

@MainActor
@Observable
final class HomeViewModel {
    private(set) var nowShowingMovies: [Movie] = []
    private(set) var popularMovies: [Movie] = []

    private(set) var isLoadingNowShowing = true
    private(set) var isLoadingPopular = true

    private(set) var nowShowingError: String?
    private(set) var popularError: String?
    private(set) var errorMessage: String?

    var isLoadingMoreNowShowing: Bool { nowShowingPagination.isLoadingMore }
    var isLoadingMorePopular: Bool { popularPagination.isLoadingMore }

    var loadsAreComplete: Bool {
        !isLoadingNowShowing && !isLoadingPopular
    }

    var shouldShowFullScreenError: Bool {
        loadsAreComplete
            && nowShowingMovies.isEmpty
            && popularMovies.isEmpty
            && errorMessage != nil
    }

    private var nowShowingPagination = PaginationState()
    private var popularPagination = PaginationState()
    private let repository: MediaRepositoryProtocol

    init(repository: MediaRepositoryProtocol = MediaRepository()) {
        self.repository = repository
    }

    // MARK: - Public

    func loadMovies() async {
        Log.debug("HomeViewModel.loadMovies started", category: .home)
        resetState()

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadSection(.nowShowing, page: 1) }
            group.addTask { await self.loadSection(.popular, page: 1) }
        }

        resolveGlobalError()

        Log.debug(
            "HomeViewModel.loadMovies finished (nowShowing: \(nowShowingMovies.count), popular: \(popularMovies.count))",
            category: .home
        )
    }

    func loadMoreNowShowing() async {
        await loadMore(section: .nowShowing)
    }

    func loadMorePopular() async {
        await loadMore(section: .popular)
    }

    // MARK: - Generic section loader

    private enum Section {
        case nowShowing, popular
    }

    private func loadSection(_ section: Section, page: Int) async {
        do {
            let result: (movies: [Movie], pageInfo: PageInfo?)
            switch section {
            case .nowShowing:
                result = try await repository.fetchTrending(page: page, perPage: Design.Network.perPage)
                nowShowingMovies = result.movies
                isLoadingNowShowing = false
                nowShowingError = nil
                applyPageInfo(&nowShowingPagination, result.pageInfo, requestedPage: page)
            case .popular:
                result = try await repository.fetchPopular(page: page, perPage: Design.Network.perPage)
                popularMovies = result.movies
                isLoadingPopular = false
                popularError = nil
                applyPageInfo(&popularPagination, result.pageInfo, requestedPage: page)
            }
        } catch {
            let message = error.localizedDescription
            switch section {
            case .nowShowing:
                isLoadingNowShowing = false
                nowShowingError = message
                nowShowingPagination.hasNextPage = false
            case .popular:
                isLoadingPopular = false
                popularError = message
                popularPagination.hasNextPage = false
            }
        }
    }

    private func loadMore(section: Section) async {
        let pagination: PaginationState
        switch section {
        case .nowShowing: pagination = nowShowingPagination
        case .popular: pagination = popularPagination
        }
        guard !pagination.isLoadingMore, pagination.hasNextPage else { return }

        setPaginationLoading(section, true)
        let nextPage = pagination.currentPage + 1

        do {
            let result: (movies: [Movie], pageInfo: PageInfo?)
            switch section {
            case .nowShowing:
                result = try await repository.fetchTrending(page: nextPage, perPage: Design.Network.perPage)
                appendUnique(&nowShowingMovies, result.movies)
                applyPageInfo(&nowShowingPagination, result.pageInfo, requestedPage: nextPage)
            case .popular:
                result = try await repository.fetchPopular(page: nextPage, perPage: Design.Network.perPage)
                appendUnique(&popularMovies, result.movies)
                applyPageInfo(&popularPagination, result.pageInfo, requestedPage: nextPage)
            }
        } catch {
            Log.error("Load more \(section) page \(nextPage) failed: \(error)", category: .home)
        }

        setPaginationLoading(section, false)
    }

    // MARK: - Helpers

    private func resetState() {
        errorMessage = nil
        nowShowingError = nil
        popularError = nil
        isLoadingNowShowing = true
        isLoadingPopular = true
        nowShowingPagination = PaginationState()
        popularPagination = PaginationState()
    }

    private func resolveGlobalError() {
        guard nowShowingMovies.isEmpty, popularMovies.isEmpty else {
            errorMessage = nil
            return
        }
        if let e1 = nowShowingError, let e2 = popularError, e1 != e2 {
            errorMessage = "\(e1)\n\(e2)"
        } else {
            errorMessage = nowShowingError ?? popularError
        }
    }

    private func setPaginationLoading(_ section: Section, _ value: Bool) {
        switch section {
        case .nowShowing: nowShowingPagination.isLoadingMore = value
        case .popular: popularPagination.isLoadingMore = value
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

    private func appendUnique(_ array: inout [Movie], _ newItems: [Movie]) {
        let existing = Set(array.map(\.id))
        array.append(contentsOf: newItems.filter { !existing.contains($0.id) })
    }
}

private struct PaginationState {
    var currentPage = 0
    var hasNextPage = true
    var isLoadingMore = false
}
