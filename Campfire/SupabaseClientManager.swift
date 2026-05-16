import Foundation

class SupabaseClientManager {
    static let shared = SupabaseClientManager()
    
    private let baseURL = SupabaseConfig.url
    private let anonKey = SupabaseConfig.anonKey
    private var sessionToken: String?
    
    // MARK: - Auth
    func signInAnonymously() async throws -> User {
        let url = baseURL.appendingPathComponent("auth/v1/signup")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        
        let payload = ["email": "anon@campfire.local", "password": UUID().uuidString]
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AuthResponse.self, from: data)
        
        sessionToken = response.session.access_token
        let userId = UUID(uuidString: response.user.id) ?? UUID()
        
        // Upsert user to DB
        try await upsertUser(id: userId)
        
        return try await fetchUser(id: userId)
    }
    
    func signOut() async {
        sessionToken = nil
    }
    
    // MARK: - Users
    private func upsertUser(id: UUID) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/users")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        request.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        
        let payload = ["id": id.uuidString]
        request.httpBody = try JSONEncoder().encode(payload)
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    func fetchUser(id: UUID) async throws -> User {
        let url = baseURL.appendingPathComponent("rest/v1/users")
            .appendingQueryParameters(["id": "eq.\(id.uuidString)"])
        
        var request = URLRequest(url: url)
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let users = try JSONDecoder().decode([User].self, from: data)
        
        return users.first ?? User(id: id, createdAt: Date())
    }
    
    // MARK: - Waiting Queue
    func addToWaitingQueue(userId: UUID) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/waiting_queue")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        request.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        
        let payload = ["user_id": userId.uuidString, "status": "waiting"]
        request.httpBody = try JSONEncoder().encode(payload)
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    func removeFromWaitingQueue(queueId: UUID) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/waiting_queue")
            .appendingQueryParameters(["id": "eq.\(queueId.uuidString)"])
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: - Rooms
    func watchRoomsForUser(userId: UUID) -> AsyncStream<Room> {
        AsyncStream { continuation in
            Task {
                do {
                    let url = baseURL.appendingPathComponent("rest/v1/rooms")
                        .appendingQueryParameters([
                            "or": "(\(userId.uuidString)=user1_id,\(userId.uuidString)=user2_id)"
                        ])
                    
                    var request = URLRequest(url: url)
                    request.setValue(anonKey, forHTTPHeaderField: "apikey")
                    
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let rooms = try JSONDecoder().decode([Room].self, from: data)
                    
                    if let room = rooms.first {
                        continuation.yield(room)
                    }
                } catch {
                    continuation.finish()
                }
            }
        }
    }
    
    // MARK: - Messages
    func sendMessage(roomId: UUID, senderId: UUID, choiceId: String) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/messages")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        request.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        
        let payload: [String: String] = [
            "room_id": roomId.uuidString,
            "sender_id": senderId.uuidString,
            "choice_id": choiceId
        ]
        request.httpBody = try JSONEncoder().encode(payload)
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    func watchMessages(roomId: UUID) -> AsyncStream<[Message]> {
        AsyncStream { continuation in
            Task {
                do {
                    let url = baseURL.appendingPathComponent("rest/v1/messages")
                        .appendingQueryParameters(["room_id": "eq.\(roomId.uuidString)"])
                    
                    var request = URLRequest(url: url)
                    request.setValue(anonKey, forHTTPHeaderField: "apikey")
                    request.setValue("order=created_at.asc", forHTTPHeaderField: "Range")
                    
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let messages = try JSONDecoder().decode([Message].self, from: data)
                    
                    continuation.yield(messages)
                } catch {
                    continuation.finish()
                }
            }
        }
    }
    
    // MARK: - Choices
    func fetchChoices() async throws -> [Choice] {
        let url = baseURL.appendingPathComponent("rest/v1/choices")
        var request = URLRequest(url: url)
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Choice].self, from: data)
    }
    
    // MARK: - Room Status
    func endRoom(roomId: UUID) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/rooms")
            .appendingQueryParameters(["id": "eq.\(roomId.uuidString)"])
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        
        let payload: [String: Any] = [
            "status": "ended",
            "ended_at": ISO8601DateFormatter().string(from: Date())
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: - Reports & Blocks
    func reportUser(reporterId: UUID, reportedId: UUID, roomId: UUID, reason: String) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/reports")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        request.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        
        let payload: [String: String] = [
            "reporter_id": reporterId.uuidString,
            "reported_id": reportedId.uuidString,
            "room_id": roomId.uuidString,
            "reason": reason
        ]
        request.httpBody = try JSONEncoder().encode(payload)
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    func blockUser(blockerId: UUID, blockedId: UUID) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/blocks")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        request.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        
        let payload: [String: String] = [
            "blocker_id": blockerId.uuidString,
            "blocked_id": blockedId.uuidString
        ]
        request.httpBody = try JSONEncoder().encode(payload)
        
        _ = try await URLSession.shared.data(for: request)
    }
}

// MARK: - Helper Structs
struct AuthResponse: Codable {
    let user: AuthUser
    let session: AuthSession
}

struct AuthUser: Codable {
    let id: String
}

struct AuthSession: Codable {
    let access_token: String
}

extension URL {
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url!
    }
}
