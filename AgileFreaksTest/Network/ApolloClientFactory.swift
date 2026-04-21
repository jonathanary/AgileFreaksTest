import Apollo
import Foundation

enum ApolloClientFactory {
    static func makeClient() -> ApolloClient {
        ApolloClient(url: URL(string: Design.Network.baseURL)!)
    }
}
