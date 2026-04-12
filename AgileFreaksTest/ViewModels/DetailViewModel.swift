import Foundation

@MainActor
@Observable
final class DetailViewModel {
    private(set) var media: Media?
    /// Starts true so the detail screen shows a loading state on the first frame before `loadDetail` runs.
    private(set) var isLoading = true
    private(set) var errorMessage: String?

    var isBookmarked = false

    private let client = GraphQLClient.shared

    func loadDetail(id: Int) async {
        isLoading = true
        errorMessage = nil
        media = nil

        do {
            let variables: [String: Any] = ["id": id]
            let data: MediaData = try await client.execute(
                query: GraphQLQueries.mediaDetail,
                variables: variables
            )
            media = data.Media
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// Populated for SwiftUI previews (no network).
    static func previewLoaded() -> DetailViewModel {
        let vm = DetailViewModel()
        vm.media = Media.mockDetail
        vm.isLoading = false
        vm.errorMessage = nil
        return vm
    }
}
