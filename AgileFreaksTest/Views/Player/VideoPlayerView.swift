import AVKit
import SwiftUI

struct VideoPlayerView: View {
    let url: URL

    @Environment(Router.self) private var router
    @State private var viewModel: PlayerViewModel
    @State private var showBrowser = false

    init(url: URL, viewModel: PlayerViewModel? = nil) {
        self.url = url
        let resolved = viewModel ?? PlayerViewModel(
            mainPlayer: AVVideoPlayer(),
            adPlayer: AVVideoPlayer()
        )
        _viewModel = State(initialValue: resolved)
    }

    private var isAdPlaying: Bool {
        if case .playingAd = viewModel.state { return true }
        return false
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                Color.black

                // Ad fills the whole screen *under* the minimized main player.
                adPlayerLayer(size: proxy.size)

                // Main player keeps its identity across state changes so the
                // underlying AVPlayerViewController is never rebuilt.
                mainPlayerLayer(size: proxy.size)

                // Banner sits on the left, above both video layers.
                bannerOverlay
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .animation(.easeInOut(duration: 0.35), value: isAdPlaying)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { router.pop() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(Design.Spacing.sm)
                        .background(Circle().fill(Color.overlayDark))
                }
                .accessibilityLabel("Close player")
            }
        }
        .sheet(isPresented: $showBrowser) {
            if let detailURL = viewModel.ad.detailURL {
                InAppBrowserView(url: detailURL)
                    .ignoresSafeArea()
            }
        }
        .onAppear { viewModel.onAppear(url: url) }
        .onDisappear { viewModel.onDisappear() }
    }

    // MARK: - Layers

    private static let miniWidth: CGFloat = 160
    private static let miniHeight: CGFloat = 160 * 9 / 16

    @ViewBuilder
    private func mainPlayerLayer(size: CGSize) -> some View {
        if let avPlayer = (viewModel.mainPlayer as? AVVideoPlayer)?.player {
            PlayerView(
                player: avPlayer,
                showsPlaybackControls: !isAdPlaying,
                allowsPictureInPicturePlayback: false
            )
            .frame(
                width: isAdPlaying ? Self.miniWidth : size.width,
                height: isAdPlaying ? Self.miniHeight : size.height
            )
            .clipShape(RoundedRectangle(cornerRadius: isAdPlaying ? Design.CornerRadius.medium : 0))
            .overlay(
                RoundedRectangle(cornerRadius: isAdPlaying ? Design.CornerRadius.medium : 0)
                    .strokeBorder(Color.white.opacity(isAdPlaying ? 0.3 : 0), lineWidth: 1)
            )
            .padding(isAdPlaying ? Design.Spacing.lg : 0)
            .allowsHitTesting(!isAdPlaying)
        }
    }

    @ViewBuilder
    private func adPlayerLayer(size: CGSize) -> some View {
        if isAdPlaying, let avPlayer = (viewModel.adPlayer as? AVVideoPlayer)?.player {
            PlayerView(
                player: avPlayer,
                showsPlaybackControls: false,
                allowsPictureInPicturePlayback: false
            )
            .frame(width: size.width, height: size.height)
            .allowsHitTesting(false)
            .transition(.opacity)
        }
    }

    @ViewBuilder
    private var bannerOverlay: some View {
        if case .playingAd(let ad, let remaining) = viewModel.state {
            HStack(alignment: .center) {
                AdBanner(
                    ad: ad,
                    remaining: remaining,
                    onSeeMore: { showBrowser = true }
                )
                .padding(.leading, Design.Spacing.xxl)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .transition(.opacity)
        }
    }
}

#Preview {
    NavigationStack {
        // swiftlint:disable:next force_unwrapping
        let url = URL(string: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!
        VideoPlayerView(url: url)
    }
    .environment(Router())
}
