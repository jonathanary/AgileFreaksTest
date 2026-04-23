import AVFoundation
import SwiftUI

private enum RootAppearanceLog {
    static var didMark = false
}

@main
struct AgileFreaksTestApp: App {
    @State private var router = Router()

    init() {
        Log.debug("App init", category: .app)
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
        } catch {
            Log.error("Audio session setup failed: \(error.localizedDescription)", category: .player)
        }
    }

    var body: some Scene {
        WindowGroup {
            @Bindable var bindableRouter = router
            TabView {
                NavigationStack(path: $bindableRouter.path) {
                    HomeView()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .detail(let mediaId):
                                DetailView(mediaId: mediaId)
                            }
                        }
                }
                .environment(router)
                .font(.merriweather(.body))
                .tabItem {
                    Label("Home", image: "tab1")
                }

                NavigationStack {
                    Text("Search")
                        .font(.merriweather(.title, weight: .bold))
                        .foregroundStyle(Color.secondaryLabel)
                        .navigationTitle("Search")
                }
                .tabItem {
                    Label("Tab2", image: "tab2")
                }

                NavigationStack {
                    Text("Saved")
                        .font(.merriweather(.title, weight: .bold))
                        .foregroundStyle(Color.secondaryLabel)
                        .navigationTitle("Saved")
                }
                .tabItem {
                    Label("Tab3", image: "tab3")
                }
            }
            .fullScreenCover(item: $bindableRouter.presentedVideo) { item in
                NavigationStack {
                    VideoPlayerView(url: item.url)
                }
                .environment(router)
            }
            .tint(Color.accentColor)
            .onAppear {
                guard !RootAppearanceLog.didMark else { return }
                RootAppearanceLog.didMark = true
                Log.debug("Root TabView appeared", category: .app)
            }
        }
    }
}
