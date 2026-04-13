import Testing
@testable import AgileFreaksTest

@Suite("MediaTrailer URL")
struct MediaTrailerTests {

    @Test("YouTube URL")
    func youTubeURL() {
        let trailer = MediaTrailer(id: "abc123", site: "youtube", thumbnail: nil)
        #expect(trailer.url?.absoluteString == "https://www.youtube.com/watch?v=abc123")
    }

    @Test("YouTube is case-insensitive")
    func youTubeCaseInsensitive() {
        let trailer = MediaTrailer(id: "abc123", site: "YouTube", thumbnail: nil)
        #expect(trailer.url?.absoluteString == "https://www.youtube.com/watch?v=abc123")
    }

    @Test("Dailymotion URL")
    func dailymotionURL() {
        let trailer = MediaTrailer(id: "xyz", site: "dailymotion", thumbnail: nil)
        #expect(trailer.url?.absoluteString == "https://www.dailymotion.com/video/xyz")
    }

    @Test("Unknown site returns nil")
    func unknownSiteReturnsNil() {
        let trailer = MediaTrailer(id: "vid", site: "vimeo", thumbnail: nil)
        #expect(trailer.url == nil)
    }

    @Test("Nil id returns nil")
    func nilIdReturnsNil() {
        let trailer = MediaTrailer(id: nil, site: "youtube", thumbnail: nil)
        #expect(trailer.url == nil)
    }

    @Test("Nil site returns nil")
    func nilSiteReturnsNil() {
        let trailer = MediaTrailer(id: "abc", site: nil, thumbnail: nil)
        #expect(trailer.url == nil)
    }

    @Test("Both nil returns nil")
    func bothNilReturnsNil() {
        let trailer = MediaTrailer(id: nil, site: nil, thumbnail: nil)
        #expect(trailer.url == nil)
    }
}
