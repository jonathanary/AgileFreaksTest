import Foundation
@testable import AgileFreaksTest

final class MockGraphQLClient: GraphQLClientProtocol, @unchecked Sendable {
    var executeResult: Any?
    var executeError: Error?
    var executeCalled = false
    var lastQuery: String?
    var lastVariables: [String: Any]?

    func execute<T: Decodable>(query: String, variables: [String: Any]) async throws -> T {
        executeCalled = true
        lastQuery = query
        lastVariables = variables

        if let error = executeError { throw error }

        guard let result = executeResult as? T else {
            throw NetworkError.invalidResponse
        }
        return result
    }
}
