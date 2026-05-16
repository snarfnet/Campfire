import SwiftUI

struct ReportView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ReportBlockViewModel()
    let room: Room
    let currentUser: User
    @State private var selectedReason = ""

    let reasons = [
        "スパムや広告",
        "不適切な内容",
        "いやがらせ",
        "詐欺やなりすまし",
        "その他"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("理由を選ぶ")) {
                    Picker("理由", selection: $selectedReason) {
                        ForEach(reasons, id: \.self) { reason in
                            Text(reason).tag(reason)
                        }
                    }
                }

                Section {
                    Button(action: {
                        let otherUserId = room.user1Id == currentUser.id ? room.user2Id : room.user1Id
                        viewModel.reportUser(
                            reporterId: currentUser.id,
                            reportedId: otherUserId,
                            roomId: room.id,
                            reason: selectedReason
                        )
                        viewModel.blockUser(blockerId: currentUser.id, blockedId: otherUserId)
                        dismiss()
                    }) {
                        Text("通報してブロック")
                            .foregroundColor(.red)
                    }
                    .disabled(selectedReason.isEmpty)
                }
            }
            .navigationTitle("通報")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
