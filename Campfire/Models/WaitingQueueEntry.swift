import Foundation

struct WaitingQueueEntry: Codable {
    let id: UUID
    let userId: UUID
    var status: QueueStatus = .waiting
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case status
        case createdAt = "created_at"
    }
}

enum QueueStatus: String, Codable {
    case waiting
    case matched
}
