import Combine
import Foundation

/// Minimal playback surface the view model drives. The only seam we need for
/// tests: fake this and you can exercise the full ad-swap flow with no AVKit.
@MainActor
protocol VideoPlayer: AnyObject {
    var currentTime: AnyPublisher<TimeInterval, Never> { get }
    var didFinish: AnyPublisher<Void, Never> { get }

    func load(url: URL)
    func play()
    func pause()
    func setMuted(_ muted: Bool)

    /// Fires `handler` once when playback crosses `time`. Returning an
    /// `AnyCancellable` lets callers tear the observer down deterministically.
    @discardableResult
    func observeBoundary(at time: TimeInterval, handler: @escaping @MainActor () -> Void) -> AnyCancellable
}
