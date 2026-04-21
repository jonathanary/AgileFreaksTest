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
        let errors = [APIGraphQLError(message: "Not found", status: 404)]
        let error = NetworkError.graphQLErrors(errors)
        #expect(error.errorDescription == "Not found")
    }

    @Test("Multiple GraphQL errors are comma-joined")
    func multipleGraphQLErrorsJoined() {
        let errors = [
            APIGraphQLError(message: "Error A", status: nil),
            APIGraphQLError(message: "Error B", status: nil)
        ]
        let error = NetworkError.graphQLErrors(errors)
        #expect(error.errorDescription == "Error A, Error B")
    }

    @Test("Decoding error wraps underlying description")
    func decodingErrorDescription() {
        let error = NetworkError.decodingError("bad json")
        #expect(error.errorDescription?.contains("bad json") == true)
    }

    @Test("Network error forwards underlying description")
    func networkErrorDescription() {
        let error = NetworkError.networkError("No connection")
        #expect(error.errorDescription == "No connection")
    }
}
