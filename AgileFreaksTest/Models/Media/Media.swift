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

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Media, rhs: Media) -> Bool { lhs.id == rhs.id }
}
