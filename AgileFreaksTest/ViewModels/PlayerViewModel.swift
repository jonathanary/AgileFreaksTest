import Combine
import Foundation
import UIKit

@MainActor
@Observable
final class PlayerViewModel {
    private(set) var state: PlayerState = .playingMain

    let mainPlayer: VideoPlayer
    let adPlayer: VideoPlayer
    let ad: Ad

    @ObservationIgnored private var boundary: AnyCancellable?
    @ObservationIgnored private var adFinish: AnyCancellable?
    @ObservationIgnored private var adTicker: AnyCancellable?
    @ObservationIgnored private var bgCancellable: AnyCancellable?
    @ObservationIgnored private var fgCancellable: AnyCancellable?

    init(
        mainPlayer: VideoPlayer,
        adPlayer: VideoPlayer,
        ad: Ad = .dunkinMock
    ) {
        self.mainPlayer = mainPlayer
        self.adPlayer = adPlayer
        self.ad = ad
    }

    // MARK: - Lifecycle

    func onAppear(url: URL) {
        mainPlayer.load(url: url)
        mainPlayer.play()
        // Set the 15 seconds boundary
        boundary = mainPlayer.observeBoundary(at: 15) { [weak self] in
            self?.startAd()
        }
        subscribeToLifecycle()
        Log.debug("Player onAppear \(url.absoluteString)", category: .player)
    }

    func onDisappear() {
        boundary?.cancel()
        adFinish?.cancel()
        adTicker?.cancel()
        bgCancellable?.cancel()
        fgCancellable?.cancel()
        mainPlayer.pause()
        adPlayer.pause()
        Log.debug("Player onDisappear", category: .player)
    }

    private func subscribeToLifecycle() {
        bgCancellable?.cancel()
        fgCancellable?.cancel()
        let nc = NotificationCenter.default
        bgCancellable = nc.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in self?.handleDidEnterBackground() }
        fgCancellable = nc.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in self?.handleWillEnterForeground() }
    }

    private func handleDidEnterBackground() {
        mainPlayer.pause()
        adPlayer.pause()
        Log.debug("Player backgrounded, paused both", category: .player)
    }

    private func handleWillEnterForeground() {
        switch state {
        case .playingMain:
            mainPlayer.play()
        case .playingAd:
            // Main stays paused while the ad runs so we do not decode two HLS streams.
            adPlayer.play()
        }
        Log.debug("Player foregrounded, resumed state=\(state)", category: .player)
    }

    // MARK: - Ad swap

    private func startAd() {
        Log.debug("Ad triggered: \(ad.name)", category: .player)

        // Pause main so only one HLS pipeline is active; muted-but-still-playing
        // keeps two AVPlayerItems decoding and spams Fig / HAL errors on Simulator.
        mainPlayer.pause()
        mainPlayer.setMuted(true)
        adPlayer.load(url: ad.streamURL)
        adPlayer.play()
        state = .playingAd(ad, remaining: ad.duration)

        adFinish = adPlayer.didFinish
            .sink { [weak self] in self?.endAd() }

        adTicker = adPlayer.currentTime
            .sink { [weak self] time in
                guard let self, case .playingAd(let ad, _) = self.state else { return }
                let remaining = max(0, ad.duration - time)
                self.state = .playingAd(ad, remaining: remaining)
            }
    }

    private func endAd() {
        adPlayer.pause()
        mainPlayer.setMuted(false)
        mainPlayer.play()
        adFinish?.cancel()
        adTicker?.cancel()
        state = .playingMain
        Log.debug("Ad finished, main restored", category: .player)
    }
}
