import SwiftUI

enum Route: Hashable {
    case detail(mediaId: Int)
    case videoPlayer(url: URL)
}

@MainActor
@Observable
final class Router {
    var path = NavigationPath()

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
}
