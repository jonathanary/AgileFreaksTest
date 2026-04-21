import Foundation

enum MediaMapper {

    // MARK: - Apollo → Movie

    static func mapNowShowing(_ media: AniListAPI.NowShowingMoviesQuery.Data.Page.Medium) -> Movie {
        Movie(
            id: media.id,
            displayTitle: resolveTitle(english: media.title?.english, romaji: media.title?.romaji, native: media.title?.native),
            score: formatScore(media.averageScore),
            duration: formatDuration(media.duration),
            language: "Unknown",
            description: "",
            genres: normalizedGenres(media.genres),
            format: "N/A",
            coverImageURL: media.coverImage?.large ?? media.coverImage?.extraLarge ?? media.coverImage?.medium,
            bannerImageURL: nil,
            trailerURL: nil,
            cast: []
        )
    }

    static func mapPopular(_ media: AniListAPI.PopularMoviesQuery.Data.Page.Medium) -> Movie {
        Movie(
            id: media.id,
            displayTitle: resolveTitle(english: media.title?.english, romaji: media.title?.romaji, native: media.title?.native),
            score: formatScore(media.averageScore),
            duration: formatDuration(media.duration),
            language: resolveLanguage(media.countryOfOrigin),
            description: "",
            genres: normalizedGenres(media.genres),
            format: "N/A",
            coverImageURL: media.coverImage?.large ?? media.coverImage?.extraLarge ?? media.coverImage?.medium,
            bannerImageURL: media.bannerImage ?? media.coverImage?.extraLarge,
            trailerURL: nil,
            cast: []
        )
    }

    static func mapDetail(_ media: AniListAPI.MediaDetailQuery.Data.Media) -> Movie {
        Movie(
            id: media.id,
            displayTitle: resolveTitle(english: media.title?.english, romaji: media.title?.romaji, native: media.title?.native),
            score: formatScore(media.averageScore),
            duration: formatDuration(media.duration),
            language: resolveLanguage(media.countryOfOrigin),
            description: stripHTML(media.description),
            genres: normalizedGenres(media.genres),
            format: media.format?.rawValue ?? "N/A",
            coverImageURL: media.coverImage?.large ?? media.coverImage?.extraLarge ?? media.coverImage?.medium,
            bannerImageURL: media.bannerImage ?? media.coverImage?.extraLarge,
            trailerURL: trailerURL(id: media.trailer?.id, site: media.trailer?.site),
            cast: mapCast(media.characters)
        )
    }

    // MARK: - Field helpers

    static func resolveTitle(english: String?, romaji: String?, native: String?) -> String {
        english ?? romaji ?? native ?? "Unknown"
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

    // MARK: - Private

    private static func normalizedGenres(_ genres: [String?]?) -> [String] {
        genres?.compactMap { $0 } ?? []
    }

    /// Exposed for unit tests (`@testable import`).
    internal static func trailerPlaybackURL(id: String?, site: String?) -> URL? {
        trailerURL(id: id, site: site)
    }

    private static func trailerURL(id: String?, site: String?) -> URL? {
        guard let id, let site else { return nil }
        switch site.lowercased() {
        case "youtube":
            return URL(string: "https://www.youtube.com/watch?v=\(id)")
        case "dailymotion":
            return URL(string: "https://www.dailymotion.com/video/\(id)")
        default:
            return nil
        }
    }

    private static func mapCast(_ characters: AniListAPI.MediaDetailQuery.Data.Media.Characters?) -> [CastMember] {
        guard let edges = characters?.edges else { return [] }
        return edges.compactMap { edge -> CastMember? in
            guard let edge, let node = edge.node else { return nil }
            return CastMember(
                id: node.id,
                name: node.name?.full ?? "Unknown",
                imageURL: node.image?.large ?? node.image?.medium,
                voiceActorName: edge.voiceActors?.compactMap { $0 }.first?.name?.full
            )
        }
    }
}
