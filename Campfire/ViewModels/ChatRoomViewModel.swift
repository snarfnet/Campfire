import Foundation
import Combine

class ChatRoomViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var choices: [Choice] = []
    @Published var roomStatus: RoomStatus = .active
    @Published var error: String?
    
    private let supabaseClient = SupabaseClientManager.shared
    private let room: Room
    private let currentUserId: UUID
    
    init(room: Room, currentUserId: UUID) {
        self.room = room
        self.currentUserId = currentUserId
        loadChoices()
        watchMessages()
    }
    
    func sendChoice(choiceId: String) {
        Task {
            do {
                try await supabaseClient.sendMessage(
                    roomId: room.id,
                    senderId: currentUserId,
                    choiceId: choiceId
                )
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func endRoom() {
        Task {
            try await supabaseClient.endRoom(roomId: room.id)
            DispatchQueue.main.async {
                self.roomStatus = .ended
            }
        }
    }
    
    private func loadChoices() {
        Task {
            do {
                let choices = try await supabaseClient.fetchChoices()
                DispatchQueue.main.async {
                    self.choices = choices.sorted { $0.sortOrder < $1.sortOrder }
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    private func watchMessages() {
        Task {
            for await messages in supabaseClient.watchMessages(roomId: room.id) {
                DispatchQueue.main.async {
                    self.messages = messages.sorted { $0.createdAt < $1.createdAt }
                }
            }
        }
    }
}
