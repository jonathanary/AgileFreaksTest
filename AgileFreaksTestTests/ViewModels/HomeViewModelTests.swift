import Testing
@testable import AgileFreaksTest

@Suite("HomeViewModel", .serialized)
@MainActor
struct HomeViewModelTests {

    private let mockRepo: MockMediaRepository
    private let viewModel: HomeViewModel

    init() {
        mockRepo = MockMediaRepository()
        viewModel = HomeViewModel(repository: mockRepo)
    }

    // MARK: - Initial state

    @Test("Initial state is loading")
    func initialStateIsLoading() {
        #expect(viewModel.isLoadingNowShowing)
        #expect(viewModel.isLoadingPopular)
        #expect(viewModel.nowShowingMovies.isEmpty)
        #expect(viewModel.popularMovies.isEmpty)
    }

    // MARK: - loadMovies

    @Test("loadMovies populates both sections")
    func loadMoviesPopulatesBothSections() async {
        mockRepo.trendingResult = ([makeMovie(id: 1)], PageInfo(currentPage: 1, hasNextPage: false, perPage: 10))
        mockRepo.popularResult = ([makeMovie(id: 2)], PageInfo(currentPage: 1, hasNextPage: false, perPage: 10))

        await viewModel.loadMovies()

        #expect(viewModel.nowShowingMovies.count == 1)
        #expect(viewModel.popularMovies.count == 1)
        #expect(!viewModel.isLoadingNowShowing)
        #expect(!viewModel.isLoadingPopular)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("loadMovies sets error when both sections fail")
    func loadMoviesSetsErrorWhenBothFail() async {
        mockRepo.errorToThrow = NetworkError.invalidResponse

        await viewModel.loadMovies()

        #expect(viewModel.shouldShowFullScreenError)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.nowShowingMovies.isEmpty)
        #expect(viewModel.popularMovies.isEmpty)
    }

    @Test("Partial success does not show full-screen error")
    func loadMoviesPartialSuccess() async {
        let partialRepo = PartialFailMockRepository()
        partialRepo.trendingResult = ([makeMovie(id: 1)], nil)
        let vm = HomeViewModel(repository: partialRepo)

        await vm.loadMovies()

        #expect(vm.nowShowingMovies.count == 1)
        #expect(vm.popularMovies.isEmpty)
        #expect(!vm.shouldShowFullScreenError)
    }

    // MARK: - loadMore

    @Test("loadMore appends only unique items")
    func loadMoreNowShowingAppendsUniqueItems() async {
        mockRepo.trendingResult = ([makeMovie(id: 1)], PageInfo(currentPage: 1, hasNextPage: true, perPage: 10))
        mockRepo.popularResult = ([], nil)
        await viewModel.loadMovies()

        mockRepo.trendingResult = ([makeMovie(id: 1), makeMovie(id: 2)], PageInfo(currentPage: 2, hasNextPage: false, perPage: 10))

        await viewModel.loadMoreNowShowing()

        #expect(viewModel.nowShowingMovies.count == 2)
        #expect(viewModel.nowShowingMovies.map(\.id) == [1, 2])
    }

    @Test("loadMore is a no-op when hasNextPage is false")
    func loadMoreDoesNothingWhenNoNextPage() async {
        mockRepo.trendingResult = ([makeMovie(id: 1)], PageInfo(currentPage: 1, hasNextPage: false, perPage: 10))
        mockRepo.popularResult = ([], nil)
        await viewModel.loadMovies()

        mockRepo.fetchTrendingCallCount = 0
        await viewModel.loadMoreNowShowing()

        #expect(mockRepo.fetchTrendingCallCount == 0)
    }

    // MARK: - Computed properties

    @Test("loadsAreComplete reflects loading state")
    func loadsAreComplete() async {
        #expect(!viewModel.loadsAreComplete)

        mockRepo.trendingResult = ([], nil)
        mockRepo.popularResult = ([], nil)
        await viewModel.loadMovies()

        #expect(viewModel.loadsAreComplete)
    }

    // MARK: - Helper

    private func makeMovie(id: Int) -> Movie {
        Movie(
            id: id, displayTitle: "Movie \(id)", score: "8.0",
            duration: "1h 30m", language: "Japanese", description: "",
            genres: [], format: "Movie", coverImageURL: nil,
            bannerImageURL: nil, trailerURL: nil, cast: []
        )
    }
}

private final class PartialFailMockRepository: MediaRepositoryProtocol, @unchecked Sendable {
    var trendingResult: (movies: [Movie], pageInfo: PageInfo?) = ([], nil)

    func fetchTrending(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?) {
        trendingResult
    }

    func fetchPopular(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?) {
        throw NetworkError.invalidResponse
    }

    func fetchDetail(id: Int) async throws -> Movie {
        throw NetworkError.invalidResponse
    }
}
