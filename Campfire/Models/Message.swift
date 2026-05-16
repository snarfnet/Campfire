import Foundation

struct Message: Codable, Identifiable {
    let id: UUID
    let roomId: UUID
    let senderId: UUID
    let choiceId: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case roomId = "room_id"
        case senderId = "sender_id"
        case choiceId = "choice_id"
        case createdAt = "created_at"
    }
}
