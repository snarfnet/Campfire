import Foundation
import Combine

class MatchmakingViewModel: ObservableObject {
    @Published var matchedRoom: Room?
    @Published var isWaiting = false
    @Published var error: String?
    
    private let supabaseClient = SupabaseClientManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    func enterQueue(userId: UUID) {
        isWaiting = true
        Task {
            do {
                try await supabaseClient.addToWaitingQueue(userId: userId)
                DispatchQueue.main.async {
                    self.watchForMatch(userId: userId)
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isWaiting = false
                }
            }
        }
    }
    
    func leaveQueue(queueId: UUID) {
        Task {
            try await supabaseClient.removeFromWaitingQueue(queueId: queueId)
            DispatchQueue.main.async {
                self.isWaiting = false
            }
        }
    }
    
    private func watchForMatch(userId: UUID) {
        Task {
            for await room in supabaseClient.watchRoomsForUser(userId: userId) {
                DispatchQueue.main.async {
                    self.matchedRoom = room
                    self.isWaiting = false
                }
            }
        }
    }
}
