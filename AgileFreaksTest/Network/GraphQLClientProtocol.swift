import Foundation

protocol GraphQLClientProtocol: Sendable {
    func execute<T: Decodable>(query: String, variables: [String: Any]) async throws -> T
}
