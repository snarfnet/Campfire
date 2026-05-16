import SwiftUI

struct ReportView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ReportBlockViewModel()
    let room: Room
    let currentUser: User
    @State private var selectedReason = ""

    private let reasons = [
        "迷惑行為",
        "不適切な内容",
        "いやがらせ",
        "詐欺やなりすまし",
        "その他"
    ]

    var body: some View {
        NavigationView {
            ZStack {
                CampfireTheme.ink.ignoresSafeArea()

                Form {
                    Section(header: Text("理由を選ぶ")) {
                        Picker("理由", selection: $selectedReason) {
                            Text("選択してください").tag("")
                            ForEach(reasons, id: \.self) { reason in
                                Text(reason).tag(reason)
                            }
                        }
                    }

                    Section {
                        Button(action: reportAndBlock) {
                            Text("通報してブロック")
                                .fontWeight(.semibold)
                                .foregroundColor(selectedReason.isEmpty ? .gray : CampfireTheme.danger)
                        }
                        .disabled(selectedReason.isEmpty)
                    } footer: {
                        Text("相手には通報者は表示されません。ブロック後、この相手とは再マッチしない想定です。")
                    }
                }
            }
            .navigationTitle("通報")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func reportAndBlock() {
        let otherUserId = room.user1Id == currentUser.id ? room.user2Id : room.user1Id
        viewModel.reportUser(
            reporterId: currentUser.id,
            reportedId: otherUserId,
            roomId: room.id,
            reason: selectedReason
        )
        viewModel.blockUser(blockerId: currentUser.id, blockedId: otherUserId)
        dismiss()
    }
}
