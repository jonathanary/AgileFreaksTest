import Foundation

@MainActor
@Observable
final class DetailViewModel {
    private(set) var movie: Movie?
    private(set) var isLoading = true
    private(set) var errorMessage: String?

    private let repository: MediaRepositoryProtocol

    init(repository: MediaRepositoryProtocol = MediaRepository()) {
        self.repository = repository
    }

    func loadDetail(id: Int) async {
        isLoading = true
        errorMessage = nil
        movie = nil

        do {
            movie = try await repository.fetchDetail(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    static func previewLoaded() -> DetailViewModel {
        let vm = DetailViewModel()
        vm.movie = Movie.mockDetail
        vm.isLoading = false
        return vm
    }
}
