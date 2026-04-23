import SwiftUI

enum Route: Hashable {
    case detail(mediaId: Int)
}

@MainActor
@Observable
final class Router {
    var path = NavigationPath()
    var presentedVideoURL: URL?

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
        presentedVideoURL = url
    }

    func dismissVideo() {
        presentedVideoURL = nil
    }
}

extension URL: @retroactive Identifiable {
    public var id: URL { self }
}
