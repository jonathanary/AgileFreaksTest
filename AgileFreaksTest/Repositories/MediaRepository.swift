import Apollo
import Foundation

struct MediaRepository: MediaRepositoryProtocol {
    private let client: ApolloClient

    init(client: ApolloClient = ApolloClientFactory.makeClient()) {
        self.client = client
    }

    func fetchTrending(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?) {
        let query = AniListAPI.NowShowingMoviesQuery(
            page: .some(Int32(page)),
            perPage: .some(Int32(perPage))
        )
        let response = try await fetch(query)
        guard let pageData = response.data?.page else {
            throw NetworkError.invalidResponse
        }
        let movies = (pageData.media ?? []).compactMap { $0 }.map(MediaMapper.mapNowShowing)
        let pageInfo = pageData.pageInfo.map {
            PageInfo(currentPage: $0.currentPage, hasNextPage: $0.hasNextPage, perPage: $0.perPage)
        }
        return (movies, pageInfo)
    }

    func fetchPopular(page: Int, perPage: Int) async throws -> (movies: [Movie], pageInfo: PageInfo?) {
        let query = AniListAPI.PopularMoviesQuery(
            page: .some(Int32(page)),
            perPage: .some(Int32(perPage))
        )
        let response = try await fetch(query)
        guard let pageData = response.data?.page else {
            throw NetworkError.invalidResponse
        }
        let movies = (pageData.media ?? []).compactMap { $0 }.map(MediaMapper.mapPopular)
        let pageInfo = pageData.pageInfo.map {
            PageInfo(currentPage: $0.currentPage, hasNextPage: $0.hasNextPage, perPage: $0.perPage)
        }
        return (movies, pageInfo)
    }

    func fetchDetail(id: Int) async throws -> Movie {
        let query = AniListAPI.MediaDetailQuery(id: Int32(id))
        let response = try await fetch(query)
        guard let media = response.data?.media else {
            throw NetworkError.invalidResponse
        }
        return MediaMapper.mapDetail(media)
    }

    // MARK: - Private

    private func fetch<Q: GraphQLQuery>(_ query: Q) async throws -> Apollo.GraphQLResponse<Q>
    where Q.ResponseFormat == SingleResponseFormat {
        do {
            let response = try await client.fetch(query: query, cachePolicy: .networkOnly)
            if let errors = response.errors, !errors.isEmpty {
                throw NetworkError.graphQLErrors(
                    errors.map { APIGraphQLError(message: $0.message ?? "GraphQL error", status: nil) }
                )
            }
            return response
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error.localizedDescription)
        }
    }
}
