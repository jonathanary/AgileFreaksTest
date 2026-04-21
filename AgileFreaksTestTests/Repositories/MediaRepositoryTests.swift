import Testing
@testable import AgileFreaksTest

@Suite("MediaRepository")
struct MediaRepositoryTests {

    @Test("Repository can be constructed with default Apollo client")
    func defaultInit() {
        let repository = MediaRepository()
        _ = repository
    }
}
