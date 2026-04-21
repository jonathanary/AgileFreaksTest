import Testing
@testable import AgileFreaksTest

@Suite("Trailer playback URL")
struct MediaTrailerTests {

    @Test("YouTube URL")
    func youTubeURL() {
        let url = MediaMapper.trailerPlaybackURL(id: "abc123", site: "youtube")
        #expect(url?.absoluteString == "https://www.youtube.com/watch?v=abc123")
    }

    @Test("YouTube is case-insensitive")
    func youTubeCaseInsensitive() {
        let url = MediaMapper.trailerPlaybackURL(id: "abc123", site: "YouTube")
        #expect(url?.absoluteString == "https://www.youtube.com/watch?v=abc123")
    }

    @Test("Dailymotion URL")
    func dailymotionURL() {
        let url = MediaMapper.trailerPlaybackURL(id: "xyz", site: "dailymotion")
        #expect(url?.absoluteString == "https://www.dailymotion.com/video/xyz")
    }

    @Test("Unknown site returns nil")
    func unknownSiteReturnsNil() {
        #expect(MediaMapper.trailerPlaybackURL(id: "vid", site: "vimeo") == nil)
    }

    @Test("Nil id returns nil")
    func nilIdReturnsNil() {
        #expect(MediaMapper.trailerPlaybackURL(id: nil, site: "youtube") == nil)
    }

    @Test("Nil site returns nil")
    func nilSiteReturnsNil() {
        #expect(MediaMapper.trailerPlaybackURL(id: "abc", site: nil) == nil)
    }

    @Test("Both nil returns nil")
    func bothNilReturnsNil() {
        #expect(MediaMapper.trailerPlaybackURL(id: nil, site: nil) == nil)
    }
}
