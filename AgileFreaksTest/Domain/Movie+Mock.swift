import Foundation

extension Movie {
    static let mockList: [Movie] = [
        Movie(
            id: 101,
            displayTitle: "Spirited long mock title away now again Away",
            score: "9.6",
            duration: "2h 5m",
            language: "Japanese",
            description: "",
            genres: ["Adventure", "Fantasy"],
            format: "Movie",
            coverImageURL: "https://picsum.photos/seed/ns1/300/440",
            bannerImageURL: nil,
            trailerURL: nil,
            cast: []
        ),
        Movie(
            id: 102,
            displayTitle: "Your Name",
            score: "9.8",
            duration: "1h 46m",
            language: "Japanese",
            description: "",
            genres: ["Romance", "Drama"],
            format: "Movie",
            coverImageURL: "https://picsum.photos/seed/ns2/300/440",
            bannerImageURL: nil,
            trailerURL: nil,
            cast: []
        ),
        Movie(
            id: 103,
            displayTitle: "Akira",
            score: "8.3",
            duration: "2h 4m",
            language: "Japanese",
            description: "",
            genres: ["Action", "Sci-Fi"],
            format: "Movie",
            coverImageURL: "https://picsum.photos/seed/ns3/300/440",
            bannerImageURL: nil,
            trailerURL: nil,
            cast: []
        )
    ]

    static let mockDetail = Movie(
        id: 1,
        displayTitle: "Sample Anime Feature",
        score: "8.9",
        duration: "2h 5m",
        language: "Japanese",
        description: "A preview description so the detail screen shows body text.",
        genres: ["Fantasy", "Drama", "Adventure"],
        format: "Movie",
        coverImageURL: "https://picsum.photos/seed/cover/400/600",
        bannerImageURL: "https://picsum.photos/seed/banner/800/400",
        trailerURL: URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
        cast: [
            CastMember(id: 1, name: "Lead Hero", imageURL: "https://picsum.photos/seed/cast1/160/160", voiceActorName: nil),
            CastMember(id: 2, name: "Rival Ace", imageURL: nil, voiceActorName: nil)
        ]
    )
}
