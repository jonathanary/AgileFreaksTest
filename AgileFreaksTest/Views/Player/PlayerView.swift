import AVKit
import SwiftUI

struct PlayerView: UIViewControllerRepresentable {
    let player: AVPlayer
    var showsPlaybackControls: Bool = true
    var allowsPictureInPicturePlayback: Bool = true
    var canStartPictureInPictureAutomatically: Bool = false

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = showsPlaybackControls
        controller.allowsPictureInPicturePlayback = allowsPictureInPicturePlayback
        controller.canStartPictureInPictureAutomaticallyFromInline = canStartPictureInPictureAutomatically
        controller.videoGravity = .resizeAspect
        controller.updatesNowPlayingInfoCenter = false
        return controller
    }

    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        if controller.player !== player {
            controller.player = player
        }
        controller.showsPlaybackControls = showsPlaybackControls
    }
}
