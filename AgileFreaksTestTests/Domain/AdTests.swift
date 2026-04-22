import Foundation
import Testing
@testable import AgileFreaksTest

@Suite("Ad domain")
struct AdTests {

    @Test("dunkinMock has expected values")
    func dunkinMockValues() {
        let ad = Ad.dunkinMock
        #expect(ad.name == "Dunkin")
        #expect(ad.duration == 15)
        #expect(ad.detailURL?.absoluteString == "https://yori-api.agilefreaks.com/s/dunkin-3")
        #expect(ad.streamURL.scheme == "https")
    }
}
