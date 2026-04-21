import Foundation

/// Pagination metadata for list endpoints (domain model; not tied to GraphQL transport).
struct PageInfo: Equatable, Sendable {
    let currentPage: Int?
    let hasNextPage: Bool?
    let perPage: Int?
}
