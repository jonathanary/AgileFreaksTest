import Testing
import Foundation
@testable import AgileFreaksTest

@Suite("MediaRepository")
struct MediaRepositoryTests {

    private let mockClient: MockGraphQLClient
    private let repository: MediaRepository

    init() {
        mockClient = MockGraphQLClient()
        repository = MediaRepository(client: mockClient)
    }

    // MARK: - fetchTrending

    @Test("fetchTrending returns mapped movies")
    func fetchTrendingReturnsMappedMovies() async throws {
        let media = makeMedia(id: 1, title: "Test")
        let pageInfo = PageInfo(currentPage: 1, hasNextPage: true, perPage: 10)
        mockClient.executeResult = PageData(Page: PageResult(pageInfo: pageInfo, media: [media]))

        let result = try await repository.fetchTrending(page: 1, perPage: 10)

        #expect(result.movies.count == 1)
        #expect(result.movies.first?.id == 1)
        #expect(result.movies.first?.displayTitle == "Test")
        #expect(result.pageInfo?.hasNextPage == true)
        #expect(mockClient.executeCalled)
    }

    @Test("fetchTrending propagates network errors")
    func fetchTrendingPropagatesError() async {
        mockClient.executeError = NetworkError.invalidResponse

        await #expect(throws: NetworkError.self) {
            _ = try await repository.fetchTrending(page: 1, perPage: 10)
        }
    }

    // MARK: - fetchPopular

    @Test("fetchPopular returns mapped movies")
    func fetchPopularReturnsMappedMovies() async throws {
        let media = makeMedia(id: 2, title: "Popular")
        mockClient.executeResult = PageData(Page: PageResult(pageInfo: nil, media: [media]))

        let result = try await repository.fetchPopular(page: 1, perPage: 10)

        #expect(result.movies.count == 1)
        #expect(result.movies.first?.displayTitle == "Popular")
    }

    // MARK: - fetchDetail

    @Test("fetchDetail returns mapped movie")
    func fetchDetailReturnsMappedMovie() async throws {
        let media = makeMedia(id: 5, title: "Detail Title")
        mockClient.executeResult = MediaData(Media: media)

        let movie = try await repository.fetchDetail(id: 5)

        #expect(movie.id == 5)
        #expect(movie.displayTitle == "Detail Title")
    }

    @Test("fetchDetail propagates decoding errors")
    func fetchDetailPropagatesDecodingError() async {
        mockClient.executeError = NetworkError.decodingError(NSError(domain: "", code: 0))

        await #expect(throws: NetworkError.self) {
            _ = try await repository.fetchDetail(id: 1)
        }
    }

    // MARK: - Helper

    private func makeMedia(id: Int, title: String) -> Media {
        Media(
            id: id,
            title: MediaTitle(romaji: nil, english: title, native: nil),
            type: nil, format: nil, status: nil, description: nil,
            duration: nil, episodes: nil, seasonYear: nil,
            averageScore: nil, meanScore: nil, popularity: nil,
            genres: nil, source: nil, countryOfOrigin: nil,
            coverImage: nil, bannerImage: nil, trailer: nil,
            characters: nil
        )
    }
}
