import SwiftUI

struct EndView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            BonfireView()

            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Text("またいつか")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.71))

                    Button(action: { dismiss() }) {
                        Text("ホームへ戻る")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 1.0, green: 0.7, blue: 0.3))
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
    }
}
