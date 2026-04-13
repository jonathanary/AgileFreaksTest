import Testing
import Foundation
@testable import AgileFreaksTest

@Suite("NetworkError descriptions")
struct NetworkErrorTests {

    @Test("invalidResponse description")
    func invalidResponseDescription() {
        let error = NetworkError.invalidResponse
        #expect(error.errorDescription == "Invalid server response")
    }

    @Test("Single GraphQL error description")
    func graphQLErrorsDescription() {
        let errors = [GraphQLError(message: "Not found", status: 404)]
        let error = NetworkError.graphQLErrors(errors)
        #expect(error.errorDescription == "Not found")
    }

    @Test("Multiple GraphQL errors are comma-joined")
    func multipleGraphQLErrorsJoined() {
        let errors = [
            GraphQLError(message: "Error A", status: nil),
            GraphQLError(message: "Error B", status: nil)
        ]
        let error = NetworkError.graphQLErrors(errors)
        #expect(error.errorDescription == "Error A, Error B")
    }

    @Test("Decoding error wraps underlying description")
    func decodingErrorDescription() {
        let underlying = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "bad json"])
        let error = NetworkError.decodingError(underlying)
        #expect(error.errorDescription?.contains("bad json") == true)
    }

    @Test("Network error forwards underlying description")
    func networkErrorDescription() {
        let underlying = NSError(domain: NSURLErrorDomain, code: -1009, userInfo: [NSLocalizedDescriptionKey: "No connection"])
        let error = NetworkError.networkError(underlying)
        #expect(error.errorDescription == "No connection")
    }
}
