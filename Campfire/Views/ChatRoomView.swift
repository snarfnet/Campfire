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
                // Messages
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages, id: \.id) { message in
                            let isOwn = message.senderId == currentUser.id
                            let choice = viewModel.choices.first { $0.id == message.choiceId }
                            
                            HStack {
                                if isOwn { Spacer() }
                                
                                Text(choice?.label ?? "...")
                                    .padding(12)
                                    .background(isOwn ? Color(red: 1.0, green: 0.7, blue: 0.3) : Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .foregroundColor(isOwn ? .black : .white)
                                    .cornerRadius(8)
                                
                                if !isOwn { Spacer() }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 12)
                }
                
                Divider()
                
                // Choice Buttons
                VStack(spacing: 8) {
                    ForEach(Set(viewModel.choices.map { $0.category }).sorted { $0.rawValue < $1.rawValue }, id: \.self) { category in
                        HStack(spacing: 8) {
                            ForEach(viewModel.choices.filter { $0.category == category }.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { choice in
                                Button(action: {
                                    viewModel.sendChoice(choiceId: choice.id)
                                }) {
                                    Text(choice.label)
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .background(Color(red: 1.0, green: 0.7, blue: 0.3))
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Button(action: { viewModel.endRoom() }) {
                            Text("終わる")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(Color.red.opacity(0.7))
                                .cornerRadius(6)
                        }
                        
                        Button(action: { showReport = true }) {
                            Text("⋯")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.gray)
                                .cornerRadius(6)
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.6))
            }
            .sheet(isPresented: $showReport) {
                ReportView(room: room, currentUser: currentUser)
            }
        }
        .ignoresSafeArea()
    }
}
