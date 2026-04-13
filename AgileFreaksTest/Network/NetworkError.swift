import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse
    case graphQLErrors([GraphQLError])
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .graphQLErrors(let errors):
            return errors.map(\.message).joined(separator: ", ")
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
