import AVFoundation
import Combine
import Foundation

@MainActor
final class AVVideoPlayer: VideoPlayer {
    let player: AVPlayer

    private let currentTimeSubject = CurrentValueSubject<TimeInterval, Never>(0)
    private let didFinishSubject = PassthroughSubject<Void, Never>()

    private var periodicToken: Any?
    private var itemCancellable: AnyCancellable?

    var currentTime: AnyPublisher<TimeInterval, Never> {
        currentTimeSubject.eraseToAnyPublisher()
    }

    var didFinish: AnyPublisher<Void, Never> {
        didFinishSubject.eraseToAnyPublisher()
    }

    init(player: AVPlayer = AVPlayer()) {
        self.player = player
        attachPeriodicTimeObserver()
    }

    deinit {
        if let token = periodicToken {
            player.removeTimeObserver(token)
        }
    }

    func load(url: URL) {
        let item = AVPlayerItem(url: url)
        itemCancellable = NotificationCenter.default
            .publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
            .sink { [weak self] _ in
                MainActor.assumeIsolated { self?.didFinishSubject.send() }
            }
        player.replaceCurrentItem(with: item)
        currentTimeSubject.send(0)
    }

    func play() { player.play() }

    func pause() { player.pause() }

    func setMuted(_ muted: Bool) { player.isMuted = muted }

    @discardableResult
    func observeBoundary(
        at time: TimeInterval,
        handler: @escaping @MainActor () -> Void
    ) -> AnyCancellable {
        let boundary = NSValue(time: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        let observer = player.addBoundaryTimeObserver(
            forTimes: [boundary],
            queue: .main
        ) {
            MainActor.assumeIsolated { handler() }
        }
        return AnyCancellable { [weak self] in
            self?.player.removeTimeObserver(observer)
        }
    }

    private func attachPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        periodicToken = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            guard time.isNumeric else { return }
            MainActor.assumeIsolated {
                self?.currentTimeSubject.send(time.seconds)
            }
        }
    }
}
