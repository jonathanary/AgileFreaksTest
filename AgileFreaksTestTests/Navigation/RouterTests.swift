import Foundation
import Testing
@testable import AgileFreaksTest

@Suite("Router navigation", .serialized)
@MainActor
struct RouterTests {

    @Test("navigate appends to path")
    func navigateAppendsToPath() {
        let router = Router()
        #expect(router.path.isEmpty)

        router.navigate(to: .detail(mediaId: 42))
        #expect(router.path.count == 1)
    }

    @Test("pop removes last entry")
    func popRemovesLast() {
        let router = Router()
        router.navigate(to: .detail(mediaId: 1))
        router.navigate(to: .detail(mediaId: 2))
        #expect(router.path.count == 2)

        router.pop()
        #expect(router.path.count == 1)
    }

    @Test("pop on empty path is a no-op")
    func popOnEmptyPathDoesNothing() {
        let router = Router()
        router.pop()
        #expect(router.path.isEmpty)
    }

    @Test("popToRoot clears entire path")
    func popToRootClearsPath() {
        let router = Router()
        router.navigate(to: .detail(mediaId: 1))
        router.navigate(to: .detail(mediaId: 2))
        router.navigate(to: .detail(mediaId: 3))

        router.popToRoot()
        #expect(router.path.isEmpty)
    }

    @Test("present(video:) sets presentedVideoURL")
    func presentVideoSetsURL() {
        let router = Router()
        // swiftlint:disable:next force_unwrapping
        let url = URL(string: "https://example.com/video.m3u8")!

        router.present(video: url)

        #expect(router.presentedVideoURL == url)
    }

    @Test("dismissVideo clears presentedVideoURL without changing path")
    func dismissVideoClearsPresentationOnly() {
        let router = Router()
        // swiftlint:disable:next force_unwrapping
        let url = URL(string: "https://example.com/video.m3u8")!
        router.navigate(to: .detail(mediaId: 1))
        router.present(video: url)
        #expect(router.path.count == 1)

        router.dismissVideo()

        #expect(router.presentedVideoURL == nil)
        #expect(router.path.count == 1)
    }
}
