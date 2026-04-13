import Testing
@testable import AgileFreaksTest

@Suite("MediaMapper")
struct MediaMapperTests {

    // MARK: - Title resolution

    @Test("Prefers English title")
    func resolveTitlePrefersEnglish() {
        let title = MediaTitle(romaji: "Romaji", english: "English", native: "Native")
        #expect(MediaMapper.resolveTitle(title) == "English")
    }

    @Test("Falls back to Romaji when English is nil")
    func resolveTitleFallsBackToRomaji() {
        let title = MediaTitle(romaji: "Romaji", english: nil, native: "Native")
        #expect(MediaMapper.resolveTitle(title) == "Romaji")
    }

    @Test("Falls back to Native when English and Romaji are nil")
    func resolveTitleFallsBackToNative() {
        let title = MediaTitle(romaji: nil, english: nil, native: "Native")
        #expect(MediaMapper.resolveTitle(title) == "Native")
    }

    @Test("Returns Unknown when title is nil")
    func resolveTitleReturnsUnknownWhenNil() {
        #expect(MediaMapper.resolveTitle(nil) == "Unknown")
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

    // MARK: - Full mapping

    @Test("Maps Media DTO to Movie domain model")
    func mapMediaToMovie() {
        let media = Media(
            id: 42,
            title: MediaTitle(romaji: "R", english: "E", native: "N"),
            type: "ANIME",
            format: "MOVIE",
            status: nil,
            description: "A <b>test</b>",
            duration: 90,
            episodes: nil,
            seasonYear: nil,
            averageScore: 75,
            meanScore: nil,
            popularity: nil,
            genres: ["Action", "Drama"],
            source: nil,
            countryOfOrigin: "JP",
            coverImage: CoverImage(extraLarge: "xl", large: "lg", medium: "md", color: nil),
            bannerImage: "banner",
            trailer: MediaTrailer(id: "abc", site: "youtube", thumbnail: nil),
            characters: nil
        )

        let movie = MediaMapper.map(media)

        #expect(movie.id == 42)
        #expect(movie.displayTitle == "E")
        #expect(movie.score == "7.5")
        #expect(movie.duration == "1h 30m")
        #expect(movie.language == "Japanese")
        #expect(movie.description == "A test")
        #expect(movie.genres == ["Action", "Drama"])
        #expect(movie.format == "MOVIE")
        #expect(movie.coverImageURL == "lg")
        #expect(movie.bannerImageURL == "banner")
        #expect(movie.trailerURL?.absoluteString == "https://www.youtube.com/watch?v=abc")
        #expect(movie.cast.isEmpty)
    }

    // MARK: - Cast mapping

    @Test("Maps CharacterConnection to CastMember array")
    func mapCastWithVoiceActor() {
        let characters = CharacterConnection(edges: [
            CharacterEdge(
                node: Character(
                    id: 10,
                    name: CharacterName(full: "Hero", native: nil),
                    image: CharacterImage(large: "hero.png", medium: nil)
                ),
                role: "MAIN",
                voiceActors: [
                    Staff(id: 100, name: StaffName(full: "Actor A"), image: nil, languageV2: "Japanese")
                ]
            ),
            CharacterEdge(
                node: Character(
                    id: 20,
                    name: nil,
                    image: nil
                ),
                role: nil,
                voiceActors: nil
            ),
            CharacterEdge(node: nil, role: nil, voiceActors: nil)
        ])

        let media = Media(
            id: 99,
            title: nil, type: nil, format: nil, status: nil,
            description: nil, duration: nil, episodes: nil,
            seasonYear: nil, averageScore: nil, meanScore: nil,
            popularity: nil, genres: nil, source: nil,
            countryOfOrigin: nil, coverImage: nil, bannerImage: nil,
            trailer: nil, characters: characters
        )

        let movie = MediaMapper.map(media)

        #expect(movie.cast.count == 2)

        let hero = movie.cast[0]
        #expect(hero.id == 10)
        #expect(hero.name == "Hero")
        #expect(hero.imageURL == "hero.png")
        #expect(hero.voiceActorName == "Actor A")

        let unknown = movie.cast[1]
        #expect(unknown.id == 20)
        #expect(unknown.name == "Unknown")
        #expect(unknown.imageURL == nil)
        #expect(unknown.voiceActorName == nil)
    }

    @Test("Nil CharacterConnection produces empty cast")
    func mapCastNilConnection() {
        let media = Media(
            id: 1,
            title: nil, type: nil, format: nil, status: nil,
            description: nil, duration: nil, episodes: nil,
            seasonYear: nil, averageScore: nil, meanScore: nil,
            popularity: nil, genres: nil, source: nil,
            countryOfOrigin: nil, coverImage: nil, bannerImage: nil,
            trailer: nil, characters: nil
        )

        #expect(MediaMapper.map(media).cast.isEmpty)
    }
}
