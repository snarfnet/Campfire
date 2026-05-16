import SwiftUI

struct BonfireView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.06),
                    Color(red: 0.05, green: 0.1, blue: 0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            TimelineView(.animation) { context in
                VStack {
                    Spacer()
                    
                    // Fire
                    ZStack {
                        // Base
                        Circle()
                            .fill(Color(red: 0.3, green: 0.2, blue: 0.1))
                            .frame(width: 120, height: 60)
                        
                        // Flames
                        ForEach(0..<5, id: \.self) { index in
                            Flame()
                                .offset(x: CGFloat(index - 2) * 24)
                                .offset(y: sin(context.date.timeIntervalSince1970 * 3 + CGFloat(index) * 0.5) * 10)
                                .opacity(0.8 + 0.2 * sin(context.date.timeIntervalSince1970 * 2 + CGFloat(index)))
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct Flame: View {
    var body: some View {
        VStack(spacing: 0) {
            Ellipse()
                .fill(Color(red: 1.0, green: 0.4, blue: 0.0))
                .frame(width: 16, height: 32)
            
            Ellipse()
                .fill(Color(red: 1.0, green: 0.65, blue: 0.1))
                .frame(width: 12, height: 24)
            
            Ellipse()
                .fill(Color(red: 1.0, green: 0.85, blue: 0.2))
                .frame(width: 8, height: 16)
        }
    }
}
