import Foundation
import Testing
@testable import AgileFreaksTest

@Suite("PlayerViewModel", .serialized)
@MainActor
struct PlayerViewModelTests {

    private let main: FakeVideoPlayer
    private let adPlayer: FakeVideoPlayer
    private let viewModel: PlayerViewModel

    // swiftlint:disable force_unwrapping
    private let mainURL = URL(string: "https://example.com/main.m3u8")!
    // swiftlint:enable force_unwrapping

    init() {
        let main = FakeVideoPlayer()
        let adPlayer = FakeVideoPlayer()
        self.main = main
        self.adPlayer = adPlayer
        self.viewModel = PlayerViewModel(
            mainPlayer: main,
            adPlayer: adPlayer,
            ad: .dunkinMock
        )
    }

    @Test("onAppear loads the main URL, plays, and schedules the 15s boundary")
    func onAppearBootstraps() {
        viewModel.onAppear(url: mainURL)

        #expect(main.loadedURLs == [mainURL])
        #expect(main.playCount == 1)
        #expect(main.boundaryTimes == [15])
        #expect(viewModel.state == .playingMain)
    }

    @Test("Boundary fire swaps to ad: main muted, ad loaded + played, state updated")
    func boundaryStartsAd() {
        viewModel.onAppear(url: mainURL)
        main.fireBoundary(at: 15)

        #expect(main.mutedValues.last == true)
        #expect(adPlayer.loadedURLs == [Ad.dunkinMock.streamURL])
        #expect(adPlayer.playCount == 1)

        if case .playingAd(let ad, let remaining) = viewModel.state {
            #expect(ad.name == "Dunkin")
            #expect(remaining == Ad.dunkinMock.duration)
        } else {
            Issue.record("Expected .playingAd, got \(viewModel.state)")
        }
    }

    @Test("Ad current-time ticks update the remaining countdown")
    func adTickUpdatesRemaining() {
        viewModel.onAppear(url: mainURL)
        main.fireBoundary(at: 15)
        adPlayer.emit(time: 5)

        if case .playingAd(_, let remaining) = viewModel.state {
            #expect(remaining == Ad.dunkinMock.duration - 5)
        } else {
            Issue.record("Expected .playingAd")
        }
    }

    @Test("Ad finish unmutes main, pauses ad, and returns to .playingMain")
    func adFinishSwapsBack() {
        viewModel.onAppear(url: mainURL)
        main.fireBoundary(at: 15)

        adPlayer.fireFinished()

        #expect(main.mutedValues.last == false)
        #expect(adPlayer.pauseCount >= 1)
        #expect(viewModel.state == .playingMain)
    }

    @Test("onDisappear pauses both players and tears down observers")
    func onDisappearCleansUp() {
        viewModel.onAppear(url: mainURL)
        viewModel.onDisappear()

        #expect(main.pauseCount >= 1)
        #expect(adPlayer.pauseCount >= 1)
    }
}
