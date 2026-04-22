import Foundation

enum PlayerState: Equatable {
    case playingMain
    case playingAd(Ad, remaining: TimeInterval)
}
