import Foundation

/// GraphQL-layer error used by ``NetworkError`` (kept separate from Apollo’s `GraphQLError` type).
struct APIGraphQLError: Equatable, Sendable {
    let message: String
    let status: Int?
}
