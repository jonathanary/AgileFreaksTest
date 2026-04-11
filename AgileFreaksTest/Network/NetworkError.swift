import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case graphQLErrors([GraphQLError])
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
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
