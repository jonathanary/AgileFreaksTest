import Testing
@testable import AgileFreaksTest

@Suite("MediaMapper")
struct MediaMapperTests {

    // MARK: - Title resolution

    @Test("Prefers English title")
    func resolveTitlePrefersEnglish() {
        #expect(MediaMapper.resolveTitle(english: "English", romaji: "Romaji", native: "Native") == "English")
    }

    @Test("Falls back to Romaji when English is nil")
    func resolveTitleFallsBackToRomaji() {
        #expect(MediaMapper.resolveTitle(english: nil, romaji: "Romaji", native: "Native") == "Romaji")
    }

    @Test("Falls back to Native when English and Romaji are nil")
    func resolveTitleFallsBackToNative() {
        #expect(MediaMapper.resolveTitle(english: nil, romaji: nil, native: "Native") == "Native")
    }

    @Test("Returns Unknown when all nil")
    func resolveTitleReturnsUnknownWhenNil() {
        #expect(MediaMapper.resolveTitle(english: nil, romaji: nil, native: nil) == "Unknown")
    }

    // MARK: - Score formatting

    @Test("Converts 100-scale score to 10-scale", arguments: [
        (96, "9.6"), (83, "8.3"), (100, "10.0"), (0, "0.0")
    ])
    func formatScoreConvertsTenScale(score: Int, expected: String) {
        #expect(MediaMapper.formatScore(score) == expected)
    }

    @Test("Returns N/A for nil score")
    func formatScoreReturnsNAWhenNil() {
        #expect(MediaMapper.formatScore(nil) == "N/A")
    }

    // MARK: - Duration formatting

    @Test("Formats hours and minutes")
    func formatDurationHoursAndMinutes() {
        #expect(MediaMapper.formatDuration(125) == "2h 5m")
        #expect(MediaMapper.formatDuration(60) == "1h 0m")
    }

    @Test("Formats minutes only when under an hour")
    func formatDurationMinutesOnly() {
        #expect(MediaMapper.formatDuration(45) == "45m")
    }

    @Test("Returns N/A for nil duration")
    func formatDurationReturnsNAWhenNil() {
        #expect(MediaMapper.formatDuration(nil) == "N/A")
    }

    // MARK: - Language resolution

    @Test("Resolves known country codes", arguments: [
        ("JP", "Japanese"), ("CN", "Chinese"), ("KR", "Korean"), ("US", "English")
    ])
    func resolveLanguageKnownCodes(code: String, expected: String) {
        #expect(MediaMapper.resolveLanguage(code) == expected)
    }

    @Test("Returns raw code for unknown countries")
    func resolveLanguageUnknownCodeReturnsSelf() {
        #expect(MediaMapper.resolveLanguage("FR") == "FR")
    }

    @Test("Returns Unknown for nil country")
    func resolveLanguageNilReturnsUnknown() {
        #expect(MediaMapper.resolveLanguage(nil) == "Unknown")
    }

    // MARK: - HTML stripping

    @Test("Strips HTML tags and converts <br> to newlines")
    func stripHTMLRemovesTags() {
        let result = MediaMapper.stripHTML("A <b>bold</b> word and a <br>line.")
        #expect(result.contains("A bold word"))
        #expect(result.contains("line."))
        #expect(!result.contains("<b>"))
        #expect(!result.contains("<br>"))
    }

    @Test("Returns empty string for nil input")
    func stripHTMLNilReturnsEmpty() {
        #expect(MediaMapper.stripHTML(nil) == "")
    }

    @Test("Trims leading/trailing whitespace")
    func stripHTMLTrimsWhitespace() {
        #expect(MediaMapper.stripHTML("  hello  ") == "hello")
    }
}
