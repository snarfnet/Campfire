import SwiftUI

struct ChatRoomView: View {
    let room: Room
    let currentUser: User
    @StateObject private var viewModel: ChatRoomViewModel
    @State private var showReport = false

    init(room: Room, currentUser: User) {
        self.room = room
        self.currentUser = currentUser
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(room: room, currentUserId: currentUser.id))
    }

    var body: some View {
        ZStack {
            BonfireView()

            VStack(spacing: 0) {
                header
                    .padding(.top, 14)
                    .padding(.horizontal, 16)

                messagesView

                choiceDock
            }

            if viewModel.roomStatus == .ended {
                endedOverlay
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showReport) {
            ReportView(room: room, currentUser: currentUser)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(CampfireTheme.flame.opacity(0.18))
                    .frame(width: 44, height: 44)
                FlameShape()
                    .fill(
                        LinearGradient(
                            colors: [CampfireTheme.warm, CampfireTheme.flame, CampfireTheme.ember],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 18, height: 30)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("焚火のそば")
                    .font(.system(.headline, design: .rounded).weight(.bold))
                    .foregroundColor(CampfireTheme.paper)
                Text("選んだ言葉だけで話しています")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(CampfireTheme.paper.opacity(0.56))
            }

            Spacer()

            Button(action: { showReport = true }) {
                Image(systemName: "flag.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(CampfireTheme.paper.opacity(0.78))
                    .frame(width: 38, height: 38)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.09))
                            .overlay(Circle().stroke(Color.white.opacity(0.11), lineWidth: 1))
                    )
            }
            .accessibilityLabel("通報")
        }
        .padding(14)
        .campfirePanel(opacity: 0.58)
    }

    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 14) {
                    if viewModel.messages.isEmpty {
                        EmptyChatState()
                            .padding(.top, 52)
                    }

                    ForEach(viewModel.messages, id: \.id) { message in
                        let isOwn = message.senderId == currentUser.id
                        let choice = viewModel.choices.first { $0.id == message.choiceId }

                        MessageBubble(
                            text: choice?.label ?? "・・・",
                            isOwn: isOwn
                        )
                        .id(message.id)
                        .padding(.horizontal, 18)
                    }
                }
                .padding(.top, 18)
                .padding(.bottom, 18)
            }
            .onChange(of: viewModel.messages.count) { _ in
                guard let lastId = viewModel.messages.last?.id else { return }
                withAnimation(.easeOut(duration: 0.28)) {
                    proxy.scrollTo(lastId, anchor: .bottom)
                }
            }
        }
    }

    private var choiceDock: some View {
        VStack(spacing: 14) {
            if let error = viewModel.error {
                Text(error)
                    .font(.system(.footnote, design: .rounded).weight(.medium))
                    .foregroundColor(CampfireTheme.warm)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(groupedCategories, id: \.self) { category in
                        ChoiceCategorySection(
                            title: category.displayTitle,
                            choices: choices(in: category),
                            send: viewModel.sendChoice
                        )
                    }
                }
                .padding(.vertical, 2)
            }
            .frame(maxHeight: 230)

            HStack(spacing: 10) {
                Button(action: { viewModel.endRoom() }) {
                    Label("会話を終える", systemImage: "moon.zzz.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(CampfireSecondaryButtonStyle())

                Button(action: { showReport = true }) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .frame(width: 42)
                }
                .buttonStyle(CampfireSecondaryButtonStyle())
                .accessibilityLabel("通報")
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, 28)
        .background(
            LinearGradient(
                colors: [
                    CampfireTheme.ink.opacity(0.12),
                    CampfireTheme.ink.opacity(0.86),
                    CampfireTheme.ink
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay(
                Rectangle()
                    .fill(CampfireTheme.warm.opacity(0.13))
                    .frame(height: 1),
                alignment: .top
            )
        )
    }

    private var groupedCategories: [ChoiceCategory] {
        Array(Set(viewModel.choices.map { $0.category }))
            .sorted { $0.sortPriority < $1.sortPriority }
    }

    private func choices(in category: ChoiceCategory) -> [Choice] {
        viewModel.choices
            .filter { $0.category == category }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    private var endedOverlay: some View {
        Color.black.opacity(0.42)
            .ignoresSafeArea()
            .overlay(
                VStack(alignment: .leading, spacing: 16) {
                    Text("会話が終わりました")
                        .font(.system(.title2, design: .serif).weight(.bold))
                        .foregroundColor(CampfireTheme.paper)

                    Text("火はまだ残っています。ホームに戻って、次の相手を待てます。")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(CampfireTheme.paper.opacity(0.72))
                        .lineSpacing(4)
                }
                .padding(24)
                .campfirePanel()
                .padding(22)
            )
    }
}

private struct EmptyChatState: View {
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(CampfireTheme.flame.opacity(0.14))
                    .frame(width: 76, height: 76)

                Image(systemName: "sparkles")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(CampfireTheme.warm)
            }

            Text("最初のひと言を選んでください")
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundColor(CampfireTheme.paper)

            Text("この部屋では、下の言葉だけで会話します。")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(CampfireTheme.paper.opacity(0.58))
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }
}

private struct MessageBubble: View {
    let text: String
    let isOwn: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isOwn { Spacer(minLength: 48) }

            Text(text)
                .font(.system(.body, design: .rounded).weight(.semibold))
                .foregroundColor(isOwn ? Color(red: 0.08, green: 0.04, blue: 0.02) : CampfireTheme.paper)
                .padding(.vertical, 12)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 19, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: isOwn
                                    ? [CampfireTheme.warm, CampfireTheme.flame]
                                    : [Color.white.opacity(0.14), Color.white.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 19, style: .continuous)
                                .stroke(isOwn ? Color.white.opacity(0.24) : Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .shadow(color: isOwn ? CampfireTheme.ember.opacity(0.26) : .black.opacity(0.24), radius: 12, y: 8)
                )

            if !isOwn { Spacer(minLength: 48) }
        }
    }
}

private struct ChoiceCategorySection: View {
    let title: String
    let choices: [Choice]
    let send: (String) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 92), spacing: 8)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.caption, design: .rounded).weight(.bold))
                .foregroundColor(CampfireTheme.paper.opacity(0.56))
                .tracking(0.7)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(choices, id: \.id) { choice in
                    Button(action: {
                        send(choice.id)
                    }) {
                        Text(choice.label)
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .foregroundColor(Color(red: 0.09, green: 0.05, blue: 0.02))
                            .lineLimit(2)
                            .minimumScaleFactor(0.72)
                            .frame(maxWidth: .infinity, minHeight: 42)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [CampfireTheme.paper, CampfireTheme.warm, CampfireTheme.flame.opacity(0.86)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                    }
                }
            }
        }
    }
}

private extension ChoiceCategory {
    var displayTitle: String {
        switch self {
        case .greet:
            return "あいさつ"
        case .feel:
            return "気持ち"
        case .action:
            return "話題"
        case .end:
            return "しめる"
        }
    }

    var sortPriority: Int {
        switch self {
        case .greet:
            return 0
        case .feel:
            return 1
        case .action:
            return 2
        case .end:
            return 3
        }
    }
}
