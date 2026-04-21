import AVFoundation
import AVKit
import Combine
import SwiftUI

private enum PlaybackPhase {
    case ad
    case main
}

private let preRollURL = URL(string: "https://socialtv-staging-streams.agilefreaks.com/hls/job_671096_720p/index.m3u8")!

struct VideoPlayerView: View {
    let url: URL

    @Environment(Router.self) private var router
    @State private var adPlayer: AVPlayer
    @State private var mainPlayer: AVPlayer
    @State private var phase: PlaybackPhase = .main

    init(url: URL) {
        self.url = url
        _adPlayer = State(initialValue: AVPlayer(url: preRollURL))
        _mainPlayer = State(initialValue: {
            let player = AVPlayer(url: url)
            player.isMuted = true
            return player
        }())
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if phase == .ad {
                VideoPlayer(player: adPlayer)
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            VideoPlayer(player: mainPlayer)
                .allowsHitTesting(true)
                .frame(
                    width: phase == .ad ? 160 : nil,
                    height: phase == .ad ? 90 : nil
                )
                .clipShape(RoundedRectangle(cornerRadius: phase == .ad ? 12 : 0))
                .padding(phase == .ad ? 16 : 0)
                .ignoresSafeArea(edges: phase == .ad ? [] : .all)
        }
        .background(Color.black)
        .animation(.easeInOut(duration: 0.35), value: phase)
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
        .onAppear {
            try? AVAudioSession.sharedInstance().setCategory(.playback)
            try? AVAudioSession.sharedInstance().setActive(true)
//            adPlayer.play()
            mainPlayer.play()
        }
        .onDisappear {
            adPlayer.pause()
            adPlayer.replaceCurrentItem(with: nil)
            mainPlayer.pause()
            mainPlayer.replaceCurrentItem(with: nil)
            try? AVAudioSession.sharedInstance().setActive(false)
        }
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { note in
            guard let item = note.object as? AVPlayerItem,
                  item === mainPlayer.currentItem else { return }
            withAnimation(.easeInOut(duration: 0.35)) {
                phase = .ad
            }
            mainPlayer.isMuted = false
            adPlayer.play()
        }
    }
}

#Preview {
    NavigationStack {
        if let url = URL(string: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8") {
            VideoPlayerView(url: url)
        }
    }
    .environment(Router())
}
