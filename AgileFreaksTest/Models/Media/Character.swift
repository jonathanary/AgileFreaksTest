import Foundation

struct Character: Decodable, Identifiable, Hashable {
    let id: Int
    let name: CharacterName?
    let image: CharacterImage?
}
