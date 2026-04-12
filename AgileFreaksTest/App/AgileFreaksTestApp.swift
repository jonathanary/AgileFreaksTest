import SwiftUI

@main
struct AgileFreaksTestApp: App {
    @State private var router = Router()
    @State private var didMarkRootAppearance = false

    init() {
        Log.debug("App init", category: .app)
    }

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
                    Image("tab1")
                }

                NavigationStack {
                    Text("Search")
                        .font(.merriweather(.title, weight: .bold))
                        .foregroundStyle(Color.secondaryLabel)
                        .navigationTitle("Search")
                }
                .tabItem {
                    Image("tab2")
                }

                NavigationStack {
                    Text("Saved")
                        .font(.merriweather(.title, weight: .bold))
                        .foregroundStyle(Color.secondaryLabel)
                        .navigationTitle("Saved")
                }
                .tabItem {
                    Image("tab3")
                }
            }
            .tint(Color.accentColor)
            .environment(\.font, Font.merriweather(.body))
            .onAppear {
                guard !didMarkRootAppearance else { return }
                didMarkRootAppearance = true
                Log.debug("Root TabView appeared", category: .app)
            }
        }
    }
}
