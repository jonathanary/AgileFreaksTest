import Testing
@testable import AgileFreaksTest

@Suite("DetailViewModel", .serialized)
@MainActor
struct DetailViewModelTests {

    private let mockRepo: MockMediaRepository
    private let viewModel: DetailViewModel

    init() {
        mockRepo = MockMediaRepository()
        viewModel = DetailViewModel(repository: mockRepo)
    }

    @Test("loadDetail sets movie on success")
    func loadDetailSetsMovie() async {
        mockRepo.detailResult = makeMovie(id: 5)

        await viewModel.loadDetail(id: 5)

        #expect(viewModel.movie?.id == 5)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(mockRepo.lastFetchDetailId == 5)
    }

    @Test("loadDetail sets error on failure")
    func loadDetailSetsError() async {
        mockRepo.errorToThrow = NetworkError.invalidResponse

        await viewModel.loadDetail(id: 1)

        #expect(viewModel.movie == nil)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage != nil)
    }

    @Test("loadDetail clears previous state before fetching")
    func loadDetailClearsPreviousState() async {
        mockRepo.detailResult = makeMovie(id: 1)
        await viewModel.loadDetail(id: 1)
        #expect(viewModel.movie != nil)

        mockRepo.errorToThrow = NetworkError.invalidResponse
        mockRepo.detailResult = nil
        await viewModel.loadDetail(id: 2)

        #expect(viewModel.movie == nil)
        #expect(viewModel.errorMessage != nil)
    }

    @Test("previewLoaded returns fully populated view model")
    func previewLoadedReturnsPopulatedVM() {
        let vm = DetailViewModel.previewLoaded()
        #expect(vm.movie != nil)
        #expect(!vm.isLoading)
        #expect(vm.errorMessage == nil)
    }

    // MARK: - Helper

    private func makeMovie(id: Int) -> Movie {
        Movie(
            id: id, displayTitle: "Movie \(id)", score: "8.0",
            duration: "1h 30m", language: "Japanese", description: "Desc",
            genres: ["Action"], format: "Movie", coverImageURL: nil,
            bannerImageURL: nil, trailerURL: nil, cast: []
        )
    }
}
