import Foundation

extension Media {
    /// Short list of mock titles for SwiftUI previews (no network).
    static let mockList: [Media] = decodeMockList(
        """
        [
          {
            "id": 101,
            "title": { "english": "Spirited Away" },
            "averageScore": 96,
            "duration": 125,
            "genres": ["Adventure", "Fantasy"],
            "coverImage": { "large": "https://picsum.photos/seed/ns1/300/440" }
          },
          {
            "id": 102,
            "title": { "english": "Your Name" },
            "averageScore": 98,
            "duration": 106,
            "genres": ["Romance", "Drama"],
            "coverImage": { "large": "https://picsum.photos/seed/ns2/300/440" }
          },
          {
            "id": 103,
            "title": { "english": "Akira" },
            "averageScore": 83,
            "duration": 124,
            "genres": ["Action", "Sci-Fi"],
            "coverImage": { "large": "https://picsum.photos/seed/ns3/300/440" }
          }
        ]
        """
    )

    /// Full mock detail payload for previews: hero, description, cast, trailer.
    static let mockDetail: Media = decodeMockValue(
        """
        {
          "id": 1,
          "title": { "english": "Sample Anime Feature" },
          "description": "A <b>preview</b> description so the detail screen shows body text.",
          "averageScore": 89,
          "duration": 125,
          "genres": ["Fantasy", "Drama", "Adventure"],
          "countryOfOrigin": "JP",
          "format": "Movie",
          "bannerImage": "https://picsum.photos/seed/banner/800/400",
          "coverImage": { "large": "https://picsum.photos/seed/cover/400/600" },
          "trailer": { "id": "dQw4w9WgXcQ", "site": "youtube", "thumbnail": null },
          "characters": {
            "edges": [
              {
                "node": {
                  "id": 1,
                  "name": { "full": "Lead Hero" },
                  "image": { "large": "https://picsum.photos/seed/cast1/160/160" }
                },
                "voiceActors": []
              },
              {
                "node": {
                  "id": 2,
                  "name": { "full": "Rival Ace" },
                  "image": null
                },
                "voiceActors": []
              }
            ]
          }
        }
        """
    )

    private static func decodeMockValue(_ json: String) -> Media {
        let data = Data(json.utf8)
        return try! JSONDecoder().decode(Media.self, from: data)
    }

    private static func decodeMockList(_ json: String) -> [Media] {
        let data = Data(json.utf8)
        return try! JSONDecoder().decode([Media].self, from: data)
    }
}
