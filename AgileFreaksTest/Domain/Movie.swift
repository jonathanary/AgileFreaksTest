import Foundation

struct Movie: Identifiable, Hashable {
    let id: Int
    let displayTitle: String
    let score: String
    let duration: String
    let language: String
    let description: String
    let genres: [String]
    let format: String
    let coverImageURL: String?
    let bannerImageURL: String?
    let trailerURL: URL?
    let cast: [CastMember]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Movie, rhs: Movie) -> Bool { lhs.id == rhs.id }
}

struct CastMember: Identifiable, Hashable {
    let id: Int
    let name: String
    let imageURL: String?
    let voiceActorName: String?
}
