import Foundation

struct MediaTrailer: Decodable, Hashable {
    let id: String?
    let site: String?
    let thumbnail: String?

    var url: URL? {
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
}
