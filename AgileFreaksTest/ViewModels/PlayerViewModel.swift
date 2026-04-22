import Combine
import Foundation

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
        boundary = mainPlayer.observeBoundary(at: 15) { [weak self] in
            self?.startAd()
        }
        Log.debug("Player onAppear \(url.absoluteString)", category: .player)
    }

    func onDisappear() {
        boundary?.cancel()
        adFinish?.cancel()
        adTicker?.cancel()
        mainPlayer.pause()
        adPlayer.pause()
        Log.debug("Player onDisappear", category: .player)
    }

    // MARK: - Ad swap

    private func startAd() {
        Log.debug("Ad triggered: \(ad.name)", category: .player)

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
        adFinish?.cancel()
        adTicker?.cancel()
        state = .playingMain
        Log.debug("Ad finished, main restored", category: .player)
    }
}
