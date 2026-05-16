import SwiftUI

@main
struct CampfireApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var matchmakingVM = MatchmakingViewModel()

    var body: some Scene {
        WindowGroup {
            if let user = authManager.currentUser {
                if let room = matchmakingVM.matchedRoom {
                    ChatRoomView(room: room, currentUser: user)
                } else if matchmakingVM.isWaiting {
                    WaitingView(matchmakingVM: matchmakingVM)
                } else {
                    HomeView(authManager: authManager, matchmakingVM: matchmakingVM, user: user)
                }
            } else {
                ZStack {
                    BonfireView()
                    VStack {
                        Spacer()
                        Button(action: { authManager.signInAnonymously() }) {
                            Text("焚火へ")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 1.0, green: 0.7, blue: 0.3))
                                .cornerRadius(12)
                        }
                        .padding()
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}
