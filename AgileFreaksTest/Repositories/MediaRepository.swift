import Foundation

struct MediaRepository: MediaRepositoryProtocol {
    private let client: GraphQLClientProtocol

    init(client: GraphQLClientProtocol = GraphQLClient.shared) {
        self.client = client
    }

    func fetchTrending(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?) {
        let data: PageData = try await client.execute(
            query: GraphQLQueries.nowShowingMovies,
            variables: ["page": page, "perPage": perPage]
        )
        return (MediaMapper.mapList(data.Page.media ?? []), data.Page.pageInfo)
    }

    func fetchPopular(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?) {
        let data: PageData = try await client.execute(
            query: GraphQLQueries.popularMovies,
            variables: ["page": page, "perPage": perPage]
        )
        return (MediaMapper.mapList(data.Page.media ?? []), data.Page.pageInfo)
    }

    func fetchDetail(id: Int) async throws -> Movie {
        let data: MediaData = try await client.execute(
            query: GraphQLQueries.mediaDetail,
            variables: ["id": id]
        )
        return MediaMapper.map(data.Media)
    }
}
