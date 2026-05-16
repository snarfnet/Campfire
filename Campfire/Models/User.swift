import Foundation

struct User: Codable {
    let id: UUID
    var displayName: String?
    var isBanned: Bool = false
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case isBanned = "is_banned"
        case createdAt = "created_at"
    }
}
