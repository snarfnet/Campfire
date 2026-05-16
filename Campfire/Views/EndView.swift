import SwiftUI

struct EndView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            BonfireView()

            VStack(spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 18) {
                    Text("また、火のそばで。")
                        .font(.system(.title2, design: .serif).weight(.bold))
                        .foregroundColor(CampfireTheme.paper)

                    Text("この会話はここで終わりました。少し休んで、また別の夜へ戻れます。")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(CampfireTheme.paper.opacity(0.7))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)

                    Button(action: { dismiss() }) {
                        Text("ホームへ戻る")
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
