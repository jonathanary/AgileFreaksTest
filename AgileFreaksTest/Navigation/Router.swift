import SwiftUI

enum Route: Hashable {
    case detail(mediaId: Int)
}

/// Identity for `fullScreenCover(item:)` without extending `URL` (avoids SDK `Identifiable` clashes).
struct PresentedVideo: Identifiable, Hashable {
    let url: URL
    var id: URL { url }
}

@MainActor
@Observable
final class Router {
    var path = NavigationPath()
    var presentedVideo: PresentedVideo?

    func navigate(to route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func present(video url: URL) {
        presentedVideo = PresentedVideo(url: url)
    }

    func dismissVideo() {
        presentedVideo = nil
    }
}
