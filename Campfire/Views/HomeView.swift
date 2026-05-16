import SwiftUI

struct HomeView: View {
    @ObservedObject var authManager: AuthManager
    @ObservedObject var matchmakingVM: MatchmakingViewModel
    let user: User

    var body: some View {
        ZStack {
            BonfireView()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 18)

                Spacer()

                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("TONIGHT'S FIRE")
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .tracking(1.6)
                            .foregroundColor(CampfireTheme.warm.opacity(0.72))

                        Text("焚火チャット")
                            .font(.system(size: 44, weight: .heavy, design: .serif))
                            .foregroundColor(CampfireTheme.paper)
                            .minimumScaleFactor(0.75)
                            .lineLimit(1)

                        Text("知らない誰かと、少しだけ火を囲む。話す言葉は選択式。だから、気楽に入れます。")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(CampfireTheme.paper.opacity(0.78))
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    HStack(spacing: 10) {
                        HomeBadge(title: "匿名", caption: "名前なし")
                        HomeBadge(title: "2人", caption: "その場限り")
                        HomeBadge(title: "選択式", caption: "短い会話")
                    }

                    Button(action: {
                        matchmakingVM.enterQueue(userId: user.id)
                    }) {
                        Text("誰かと話す")
                    }
                    .buttonStyle(CampfirePrimaryButtonStyle())

                    if let error = matchmakingVM.error {
                        Text(error)
                            .font(.system(.footnote, design: .rounded).weight(.medium))
                            .foregroundColor(CampfireTheme.warm)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(CampfireTheme.danger.opacity(0.24))
                            )
                    }
                }
                .padding(24)
                .campfirePanel()
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("今夜の焚火")
                    .font(.system(.subheadline, design: .rounded).weight(.bold))
                    .foregroundColor(CampfireTheme.paper)
                Text("気軽に、短く、あとくされなく")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(CampfireTheme.paper.opacity(0.58))
            }

            Spacer()

            Circle()
                .fill(
                    RadialGradient(
                        colors: [CampfireTheme.warm, CampfireTheme.ember, .clear],
                        center: .center,
                        startRadius: 1,
                        endRadius: 18
                    )
                )
                .frame(width: 28, height: 28)
                .shadow(color: CampfireTheme.flame.opacity(0.65), radius: 16)
        }
        .padding(.horizontal, 22)
    }
}

private struct HomeBadge: View {
    let title: String
    let caption: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundColor(CampfireTheme.paper)
            Text(caption)
                .font(.system(.caption2, design: .rounded).weight(.medium))
                .foregroundColor(CampfireTheme.paper.opacity(0.58))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}
