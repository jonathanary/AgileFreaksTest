import Combine
import Foundation
@testable import AgileFreaksTest

@MainActor
final class FakeVideoPlayer: VideoPlayer {
    var loadedURLs: [URL] = []
    var playCount = 0
    var pauseCount = 0
    var mutedValues: [Bool] = []
    var boundaryTimes: [TimeInterval] = []

    private var boundaryHandlers: [TimeInterval: () -> Void] = [:]
    private let currentTimeSubject = CurrentValueSubject<TimeInterval, Never>(0)
    private let didFinishSubject = PassthroughSubject<Void, Never>()

    var currentTime: AnyPublisher<TimeInterval, Never> {
        currentTimeSubject.eraseToAnyPublisher()
    }

    var didFinish: AnyPublisher<Void, Never> {
        didFinishSubject.eraseToAnyPublisher()
    }

    func load(url: URL) {
        loadedURLs.append(url)
        currentTimeSubject.send(0)
    }

    func play() { playCount += 1 }
    func pause() { pauseCount += 1 }
    func setMuted(_ muted: Bool) { mutedValues.append(muted) }

    @discardableResult
    func observeBoundary(
        at time: TimeInterval,
        handler: @escaping @MainActor () -> Void
    ) -> AnyCancellable {
        boundaryTimes.append(time)
        boundaryHandlers[time] = handler
        return AnyCancellable { [weak self] in
            self?.boundaryHandlers.removeValue(forKey: time)
        }
    }

    // MARK: - Test drivers

    func fireBoundary(at time: TimeInterval) {
        boundaryHandlers[time]?()
    }

    func emit(time: TimeInterval) {
        currentTimeSubject.send(time)
    }

    func fireFinished() {
        didFinishSubject.send()
    }
}
