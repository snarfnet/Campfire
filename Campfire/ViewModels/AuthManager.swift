import Foundation
import Combine

class AuthManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var error: String?
    
    private let supabaseClient = SupabaseClientManager.shared
    
    func signInAnonymously() {
        isLoading = true
        Task {
            do {
                let user = try await supabaseClient.signInAnonymously()
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func signOut() {
        Task {
            await supabaseClient.signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
            }
        }
    }
}
