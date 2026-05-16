import SwiftUI

struct HomeView: View {
    @ObservedObject var authManager: AuthManager
    @ObservedObject var matchmakingVM: MatchmakingViewModel
    let user: User

    var body: some View {
        ZStack {
            BonfireView()

            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Text("焚火チャット")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.71))

                    Button(action: {
                        matchmakingVM.enterQueue(userId: user.id)
                    }) {
                        Text("誰かと話す")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 1.0, green: 0.7, blue: 0.3))
                            .cornerRadius(12)
                    }

                    if let error = matchmakingVM.error {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(24)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                .padding()
            }
        }
        .ignoresSafeArea()
    }
}
