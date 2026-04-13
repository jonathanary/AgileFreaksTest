import Foundation
@testable import AgileFreaksTest

final class MockMediaRepository: MediaRepositoryProtocol, @unchecked Sendable {
    var trendingResult: (movies: [Movie], pageInfo: PageInfo?) = ([], nil)
    var popularResult: (movies: [Movie], pageInfo: PageInfo?) = ([], nil)
    var detailResult: Movie?
    var errorToThrow: Error?

    var fetchTrendingCallCount = 0
    var fetchPopularCallCount = 0
    var fetchDetailCallCount = 0
    var lastFetchDetailId: Int?

    func fetchTrending(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?) {
        fetchTrendingCallCount += 1
        if let error = errorToThrow { throw error }
        return trendingResult
    }

    func fetchPopular(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?) {
        fetchPopularCallCount += 1
        if let error = errorToThrow { throw error }
        return popularResult
    }

    func fetchDetail(id: Int) async throws -> Movie {
        fetchDetailCallCount += 1
        lastFetchDetailId = id
        if let error = errorToThrow { throw error }
        guard let result = detailResult else { throw NetworkError.invalidResponse }
        return result
    }
}
