import Foundation

protocol MediaRepositoryProtocol: Sendable {
    func fetchTrending(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?)
    func fetchPopular(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?)
    func fetchDetail(id: Int) async throws -> Movie
}
