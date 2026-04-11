import Foundation

struct Media: Decodable, Identifiable, Hashable {
    let id: Int
    let title: MediaTitle?
    let type: String?
    let format: String?
    let status: String?
    let description: String?
    let duration: Int?
    let episodes: Int?
    let seasonYear: Int?
    let averageScore: Int?
    let meanScore: Int?
    let popularity: Int?
    let genres: [String]?
    let source: String?
    let countryOfOrigin: String?
    let coverImage: CoverImage?
    let bannerImage: String?
    let trailer: MediaTrailer?
    let characters: CharacterConnection?

    var displayTitle: String {
        title?.english ?? title?.romaji ?? title?.native ?? "Unknown"
    }

    var scoreOutOfTen: String {
        guard let score = averageScore else { return "N/A" }
        let mapped = Double(score) / 10.0
        return String(format: "%.1f", mapped)
    }

    var formattedDuration: String {
        guard let duration else { return "N/A" }
        let hours = duration / 60
        let minutes = duration % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    var languageFromCountry: String {
        switch countryOfOrigin {
        case "JP": return "Japanese"
        case "CN": return "Chinese"
        case "KR": return "Korean"
        case "US": return "English"
        default: return countryOfOrigin ?? "Unknown"
        }
    }

    var cleanDescription: String {
        guard let description else { return "" }
        return description
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
}
