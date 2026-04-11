import SwiftUI

@main
struct AgileFreaksTestApp: App {
    @State private var router = Router()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack(path: $router.path) {
                    HomeView()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .detail(let mediaId):
                                DetailView(mediaId: mediaId)
                            }
                        }
                }
                .environment(router)
                .tabItem {
                    Label("", systemImage: "film")
                }

                NavigationStack {
                    Text("Search")
                        .font(.title)
                        .foregroundStyle(.secondary)
                        .navigationTitle("Search")
                }
                .tabItem {
                    Label("", systemImage: "magnifyingglass")
                }

                NavigationStack {
                    Text("Saved")
                        .font(.title)
                        .foregroundStyle(.secondary)
                        .navigationTitle("Saved")
                }
                .tabItem {
                    Label("", systemImage: "bookmark")
                }
            }
            .tint(Color.accentColor)
        }
    }
}
