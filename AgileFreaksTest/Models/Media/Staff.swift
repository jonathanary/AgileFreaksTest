import Foundation

struct Staff: Decodable, Identifiable, Hashable {
    let id: Int
    let name: StaffName?
    let image: StaffImage?
    let languageV2: String?
}
