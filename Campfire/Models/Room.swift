import Foundation

struct Room: Codable {
    let id: UUID
    let user1Id: UUID
    let user2Id: UUID
    var status: RoomStatus = .active
    let createdAt: Date
    var endedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case user1Id = "user1_id"
        case user2Id = "user2_id"
        case status
        case createdAt = "created_at"
        case endedAt = "ended_at"
    }
}

enum RoomStatus: String, Codable {
    case active
    case ended
}
