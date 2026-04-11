import Foundation

struct CharacterEdge: Decodable, Hashable {
    let node: Character?
    let role: String?
    let voiceActors: [Staff]?
}
