import Foundation

struct PageResult: Decodable {
    let pageInfo: PageInfo?
    let media: [Media]?
}
