import SwiftUI

struct WaitingView: View {
    @ObservedObject var matchmakingVM: MatchmakingViewModel
    @State private var dots = ""
    
    var body: some View {
        ZStack {
            BonfireView()
            
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("待っています\(dots)")
                        .font(.title3)
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.71))
                        .animation(.easeInOut(duration: 0.6).repeatForever(), value: dots)
                    
                    Button(action: {
                        matchmakingVM.isWaiting = false
                    }) {
                        Text("キャンセル")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.7))
                            .cornerRadius(8)
                    }
                }
                .padding(24)
                .background(Color.black.opacity(0.4))
                .cornerRadius(12)
                .padding()
                
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animateDots()
        }
    }
    
    private func animateDots() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            dots = dots.count < 3 ? dots + "・" : ""
        }
    }
}
