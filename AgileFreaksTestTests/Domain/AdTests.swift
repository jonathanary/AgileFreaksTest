import Foundation
import Testing
@testable import AgileFreaksTest

@Suite("Ad domain")
struct AdTests {

    @Test("dunkinMock has expected values")
    func dunkinMockValues() {
        let ad = Ad.dunkinMock
        #expect(ad.name == "Dunkin")
        #expect(ad.headline == "Your Dunkin' Moment")
        #expect(ad.ctaTitle == "Grab yours now")
        #expect(ad.bannerTitle == "Your Dunkin' Moment")
        #expect(ad.bannerCTATitle == "Grab yours now")
        #expect(ad.duration == 15)
        #expect(ad.detailURL?.absoluteString == "https://yori-api.agilefreaks.com/s/dunkin-69")
        #expect(ad.streamURL.scheme == "https")
    }
}
