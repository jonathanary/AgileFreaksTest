import Foundation

enum MediaMapper {

    static func map(_ dto: Media) -> Movie {
        Movie(
            id: dto.id,
            displayTitle: resolveTitle(dto.title),
            score: formatScore(dto.averageScore),
            duration: formatDuration(dto.duration),
            language: resolveLanguage(dto.countryOfOrigin),
            description: stripHTML(dto.description),
            genres: dto.genres ?? [],
            format: dto.format ?? "N/A",
            coverImageURL: dto.coverImage?.large ?? dto.coverImage?.extraLarge ?? dto.coverImage?.medium,
            bannerImageURL: dto.bannerImage ?? dto.coverImage?.extraLarge,
            trailerURL: dto.trailer?.url,
            cast: mapCast(dto.characters)
        )
    }

    static func mapList(_ dtos: [Media]) -> [Movie] {
        dtos.map(map)
    }

    // MARK: - Field helpers

    static func resolveTitle(_ title: MediaTitle?) -> String {
        title?.english ?? title?.romaji ?? title?.native ?? "Unknown"
    }

    static func formatScore(_ averageScore: Int?) -> String {
        guard let score = averageScore else { return "N/A" }
        return String(format: "%.1f", Double(score) / 10.0)
    }

    static func formatDuration(_ minutes: Int?) -> String {
        guard let minutes else { return "N/A" }
        let hours = minutes / 60
        let mins = minutes % 60
        return hours > 0 ? "\(hours)h \(mins)m" : "\(mins)m"
    }

    static func resolveLanguage(_ countryCode: String?) -> String {
        switch countryCode {
        case "JP": return "Japanese"
        case "CN": return "Chinese"
        case "KR": return "Korean"
        case "US": return "English"
        default: return countryCode ?? "Unknown"
        }
    }

    static func stripHTML(_ raw: String?) -> String {
        guard let raw else { return "" }
        return raw
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Cast

    private static func mapCast(_ connection: CharacterConnection?) -> [CastMember] {
        guard let edges = connection?.edges else { return [] }
        return edges.compactMap { edge -> CastMember? in
            guard let node = edge.node else { return nil }
            return CastMember(
                id: node.id,
                name: node.name?.full ?? "Unknown",
                imageURL: node.image?.large ?? node.image?.medium,
                voiceActorName: edge.voiceActors?.first?.name?.full
            )
        }
    }
}
