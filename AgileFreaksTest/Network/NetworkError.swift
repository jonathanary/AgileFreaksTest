import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidResponse
    case graphQLErrors([APIGraphQLError])
    case decodingError(String)
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .graphQLErrors(let errors):
            return errors.map(\.message).joined(separator: ", ")
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .networkError(let message):
            return message
        }
    }
}
