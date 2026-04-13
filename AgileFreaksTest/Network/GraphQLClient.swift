import Foundation

actor GraphQLClient: GraphQLClientProtocol {
    static let shared = GraphQLClient()

    private let endpoint: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        endpoint: URL = URL(string: Design.Network.baseURL)!,
        session: URLSession? = nil
    ) {
        self.endpoint = endpoint
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Design.Network.timeoutInterval
        self.session = session ?? URLSession(configuration: config)
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
