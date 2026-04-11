import Foundation

actor GraphQLClient {
    static let shared = GraphQLClient()

    private let endpoint = URL(string: "https://graphql.anilist.co")!
    private let session: URLSession
    private let decoder: JSONDecoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
    }

    func execute<T: Decodable>(
        query: String,
        variables: [String: Any] = [:]
    ) async throws -> T {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body: [String: Any] = [
            "query": query,
            "variables": variables
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        let graphQLResponse: GraphQLResponse<T>
        do {
            graphQLResponse = try decoder.decode(GraphQLResponse<T>.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }

        if let errors = graphQLResponse.errors, !errors.isEmpty {
            throw NetworkError.graphQLErrors(errors)
        }

        guard let result = graphQLResponse.data else {
            throw NetworkError.invalidResponse
        }

        return result
    }
}
