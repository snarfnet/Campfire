import SwiftUI

struct WaitingView: View {
    @ObservedObject var matchmakingVM: MatchmakingViewModel
    @State private var pulse = false

    var body: some View {
        ZStack {
            BonfireView()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 22) {
                    ZStack {
                        Circle()
                            .stroke(CampfireTheme.warm.opacity(0.18), lineWidth: 1)
                            .frame(width: 132, height: 132)
                            .scaleEffect(pulse ? 1.16 : 0.92)
                            .opacity(pulse ? 0.18 : 0.7)

                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [CampfireTheme.warm, CampfireTheme.flame, CampfireTheme.ember.opacity(0.2)],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 48
                                )
                            )
                            .frame(width: 84, height: 84)
                            .shadow(color: CampfireTheme.flame.opacity(0.5), radius: 24)

                        Text("待")
                            .font(.system(size: 30, weight: .heavy, design: .serif))
                            .foregroundColor(Color(red: 0.1, green: 0.05, blue: 0.02))
                    }

                    VStack(spacing: 8) {
                        Text("相手を待っています")
                            .font(.system(.title3, design: .rounded).weight(.bold))
                            .foregroundColor(CampfireTheme.paper)

                        Text("火が消える前に、誰かが来ます。")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(CampfireTheme.paper.opacity(0.64))
                    }

                    Button(action: {
                        matchmakingVM.isWaiting = false
                    }) {
                        Text("キャンセル")
                    }
                    .buttonStyle(CampfirePrimaryButtonStyle(isDestructive: true))
                    .padding(.top, 6)
                }
                .padding(24)
                .campfirePanel()
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
