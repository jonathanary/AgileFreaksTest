import Foundation

struct Ad: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    /// Shown as the main banner line; defaults to `name` when omitted.
    let headline: String?
    /// CTA label on the pill button; defaults to `"See More"` when omitted.
    let ctaTitle: String?
    let duration: TimeInterval
    let streamURL: URL
    let detailURL: URL?

    var bannerTitle: String { headline ?? name }

    var bannerCTATitle: String { ctaTitle ?? "See More" }

    init(
        id: String = UUID().uuidString,
        name: String,
        headline: String? = nil,
        ctaTitle: String? = nil,
        duration: TimeInterval,
        streamURL: URL,
        detailURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.headline = headline
        self.ctaTitle = ctaTitle
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
        headline: "Your Dunkin' Moment",
        ctaTitle: "Grab yours now",
        duration: 15,
        streamURL: URL(string: "https://socialtv-staging-streams.agilefreaks.com/hls/job_671096_720p/index.m3u8")!,
        detailURL: URL(string: "https://yori-api.agilefreaks.com/s/dunkin-69")!
    )
    // swiftlint:enable force_unwrapping
}
