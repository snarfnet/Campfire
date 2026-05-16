import Foundation
import Combine

class ReportBlockViewModel: ObservableObject {
    @Published var error: String?
    @Published var isProcessing = false
    
    private let supabaseClient = SupabaseClientManager.shared
    
    func reportUser(reporterId: UUID, reportedId: UUID, roomId: UUID, reason: String) {
        isProcessing = true
        Task {
            do {
                try await supabaseClient.reportUser(
                    reporterId: reporterId,
                    reportedId: reportedId,
                    roomId: roomId,
                    reason: reason
                )
                DispatchQueue.main.async {
                    self.isProcessing = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isProcessing = false
                }
            }
        }
    }
    
    func blockUser(blockerId: UUID, blockedId: UUID) {
        Task {
            do {
                try await supabaseClient.blockUser(
                    blockerId: blockerId,
                    blockedId: blockedId
                )
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
