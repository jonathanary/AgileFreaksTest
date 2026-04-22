import Foundation

struct Ad: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let duration: TimeInterval
    let streamURL: URL
    let detailURL: URL?

    init(
        id: String = UUID().uuidString,
        name: String,
        duration: TimeInterval,
        streamURL: URL,
        detailURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.duration = duration
        self.streamURL = streamURL
        self.detailURL = detailURL
    }
}

extension Ad {
    // swiftlint:disable force_unwrapping
    static let dunkinMock = Ad(
        id: "dunkin-3",
        name: "Dunkin",
        duration: 15,
        streamURL: URL(string: "https://socialtv-staging-streams.agilefreaks.com/hls/job_671096_720p/index.m3u8")!,
        detailURL: URL(string: "https://yori-api.agilefreaks.com/s/dunkin-69")!
    )
    // swiftlint:enable force_unwrapping
}
