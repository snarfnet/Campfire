import SwiftUI

@main
struct CampfireApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var matchmakingVM = MatchmakingViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if let user = authManager.currentUser {
                    if let room = matchmakingVM.matchedRoom {
                        ChatRoomView(room: room, currentUser: user)
                    } else if matchmakingVM.isWaiting {
                        WaitingView(matchmakingVM: matchmakingVM)
                    } else {
                        HomeView(authManager: authManager, matchmakingVM: matchmakingVM, user: user)
                    }
                } else {
                    WelcomeGateView(authManager: authManager)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

private struct WelcomeGateView: View {
    @ObservedObject var authManager: AuthManager

    var body: some View {
        ZStack {
            BonfireView()

            VStack(spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 18) {
                    Text("焚火チャット")
                        .font(.system(size: 38, weight: .heavy, design: .serif))
                        .foregroundColor(CampfireTheme.paper)

                    Text("名前を置いて、火のそばへ。")
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundColor(CampfireTheme.warm)

                    Text("知らない誰かと、選んだ言葉だけで少し話す匿名チャットです。")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(CampfireTheme.paper.opacity(0.78))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)

                    Button(action: { authManager.signInAnonymously() }) {
                        Text("焚火へ入る")
                    }
                    .buttonStyle(CampfirePrimaryButtonStyle())
                    .padding(.top, 8)
                }
                .padding(24)
                .campfirePanel()
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
