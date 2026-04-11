import Foundation

struct PageInfo: Decodable {
    let currentPage: Int?
    let hasNextPage: Bool?
    let perPage: Int?
}
