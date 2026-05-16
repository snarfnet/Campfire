import SwiftUI

enum CampfireTheme {
    static let ink = Color(red: 0.035, green: 0.028, blue: 0.024)
    static let ash = Color(red: 0.13, green: 0.12, blue: 0.11)
    static let ember = Color(red: 0.92, green: 0.27, blue: 0.11)
    static let flame = Color(red: 1.0, green: 0.56, blue: 0.16)
    static let warm = Color(red: 1.0, green: 0.82, blue: 0.56)
    static let paper = Color(red: 1.0, green: 0.93, blue: 0.79)
    static let moss = Color(red: 0.22, green: 0.29, blue: 0.22)
    static let smoke = Color(red: 0.68, green: 0.62, blue: 0.55)
    static let danger = Color(red: 0.74, green: 0.17, blue: 0.13)
}

struct BonfireView: View {
    var body: some View {
        TimelineView(.animation) { context in
            let phase = context.date.timeIntervalSince1970

            ZStack {
                background
                emberField(phase: phase)

                VStack {
                    Spacer()
                    fireScene(phase: phase)
                        .padding(.bottom, 32)
                }
            }
        }
    }

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.025, blue: 0.03),
                    Color(red: 0.06, green: 0.045, blue: 0.035),
                    Color(red: 0.12, green: 0.08, blue: 0.045),
                    Color(red: 0.025, green: 0.035, blue: 0.03)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [
                    CampfireTheme.flame.opacity(0.34),
                    CampfireTheme.ember.opacity(0.12),
                    .clear
                ],
                center: .bottom,
                startRadius: 8,
                endRadius: 360
            )

            Canvas { context, size in
                for index in 0..<95 {
                    let x = Double((index * 73) % 100) / 100.0 * size.width
                    let y = Double((index * 41) % 100) / 100.0 * size.height
                    let opacity = 0.03 + Double(index % 5) * 0.008
                    let rect = CGRect(x: x, y: y, width: 1.1, height: 1.1)
                    context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(opacity)))
                }
            }
            .blendMode(.screen)
        }
        .ignoresSafeArea()
    }

    private func emberField(phase: TimeInterval) -> some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0..<20, id: \.self) { index in
                    let drift = CGFloat(sin(phase * 0.9 + Double(index))) * 18
                    let rise = CGFloat((phase * (0.18 + Double(index % 4) * 0.025)).truncatingRemainder(dividingBy: 1))
                    let baseX = proxy.size.width * CGFloat(0.16 + Double((index * 19) % 72) / 100.0)
                    let baseY = proxy.size.height * CGFloat(0.88 - rise * 0.44)

                    Capsule()
                        .fill((index % 3 == 0 ? CampfireTheme.warm : CampfireTheme.ember).opacity(0.34))
                        .frame(width: CGFloat(2 + index % 3), height: CGFloat(5 + index % 5))
                        .blur(radius: 0.5)
                        .position(x: baseX + drift, y: baseY)
                        .opacity(0.25 + 0.45 * (1 - rise))
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func fireScene(phase: TimeInterval) -> some View {
        ZStack {
            Ellipse()
                .fill(CampfireTheme.flame.opacity(0.18))
                .frame(width: 280, height: 116)
                .blur(radius: 26)
                .offset(y: 22)

            ForEach(0..<4, id: \.self) { index in
                SmokeWisp()
                    .stroke(CampfireTheme.smoke.opacity(0.16), lineWidth: 2)
                    .frame(width: 90, height: 150)
                    .offset(x: CGFloat(index - 2) * 24 + CGFloat(sin(phase + Double(index))) * 8, y: -112)
                    .opacity(0.45 + 0.2 * sin(phase * 0.7 + Double(index)))
            }

            ZStack {
                log(rotation: -18, x: -26)
                log(rotation: 16, x: 26)

                ForEach(0..<6, id: \.self) { index in
                    FlameShape()
                        .fill(flameGradient(index: index))
                        .frame(
                            width: CGFloat(32 + (index % 3) * 12),
                            height: CGFloat(78 + (index % 4) * 18)
                        )
                        .scaleEffect(
                            x: 0.9 + 0.08 * sin(phase * 2.7 + Double(index)),
                            y: 0.92 + 0.11 * sin(phase * 3.1 + Double(index) * 0.4),
                            anchor: .bottom
                        )
                        .offset(
                            x: CGFloat(index - 3) * 16,
                            y: CGFloat(sin(phase * 2.2 + Double(index)) * 5 - 28)
                        )
                        .blur(radius: index == 1 ? 0.4 : 0)
                        .blendMode(.screen)
                }

                FlameShape()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.86), CampfireTheme.warm.opacity(0.74), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 28, height: 70)
                    .offset(y: -36)
                    .scaleEffect(y: 0.92 + 0.09 * sin(phase * 4.2), anchor: .bottom)
                    .blendMode(.screen)
            }
        }
        .frame(height: 260)
        .accessibilityHidden(true)
    }

    private func log(rotation: Double, x: CGFloat) -> some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.36, green: 0.18, blue: 0.09),
                        Color(red: 0.16, green: 0.08, blue: 0.04),
                        Color(red: 0.45, green: 0.22, blue: 0.11)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 132, height: 22)
            .overlay(
                Capsule()
                    .stroke(Color.black.opacity(0.28), lineWidth: 1)
            )
            .rotationEffect(.degrees(rotation))
            .offset(x: x, y: 35)
            .shadow(color: .black.opacity(0.4), radius: 8, y: 8)
    }

    private func flameGradient(index: Int) -> LinearGradient {
        LinearGradient(
            colors: [
                index % 2 == 0 ? CampfireTheme.warm : .white.opacity(0.9),
                CampfireTheme.flame,
                CampfireTheme.ember,
                .clear
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct CampfirePanel: ViewModifier {
    var opacity: Double = 0.72

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(CampfireTheme.ink.opacity(opacity))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        CampfireTheme.warm.opacity(0.42),
                                        Color.white.opacity(0.07),
                                        CampfireTheme.ember.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.42), radius: 24, y: 18)
            )
    }
}

struct CampfirePrimaryButtonStyle: ButtonStyle {
    var isDestructive = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded).weight(.bold))
            .foregroundColor(isDestructive ? CampfireTheme.paper : Color(red: 0.08, green: 0.045, blue: 0.018))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: isDestructive
                                ? [CampfireTheme.danger, Color(red: 0.42, green: 0.06, blue: 0.05)]
                                : [CampfireTheme.warm, CampfireTheme.flame, CampfireTheme.ember],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: (isDestructive ? CampfireTheme.danger : CampfireTheme.ember).opacity(0.34), radius: 16, y: 8)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.86 : 1)
            .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

struct CampfireSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.subheadline, design: .rounded).weight(.semibold))
            .foregroundColor(CampfireTheme.paper)
            .padding(.vertical, 11)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.16 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
    }
}

extension View {
    func campfirePanel(opacity: Double = 0.72) -> some View {
        modifier(CampfirePanel(opacity: opacity))
    }
}

struct FlameShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY * 0.74),
            control1: CGPoint(x: rect.maxX * 0.88, y: rect.height * 0.18),
            control2: CGPoint(x: rect.maxX * 1.03, y: rect.height * 0.47)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control1: CGPoint(x: rect.maxX * 0.86, y: rect.height * 0.94),
            control2: CGPoint(x: rect.maxX * 0.64, y: rect.maxY)
        )
        path.addCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY * 0.74),
            control1: CGPoint(x: rect.maxX * 0.34, y: rect.maxY),
            control2: CGPoint(x: rect.minX * 0.1, y: rect.height * 0.92)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control1: CGPoint(x: rect.minX - rect.width * 0.06, y: rect.height * 0.42),
            control2: CGPoint(x: rect.width * 0.26, y: rect.height * 0.18)
        )
        path.closeSubpath()
        return path
    }
}

struct SmokeWisp: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addCurve(
            to: CGPoint(x: rect.midX + rect.width * 0.18, y: rect.height * 0.56),
            control1: CGPoint(x: rect.midX - rect.width * 0.26, y: rect.height * 0.86),
            control2: CGPoint(x: rect.midX + rect.width * 0.28, y: rect.height * 0.72)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX - rect.width * 0.04, y: rect.minY),
            control1: CGPoint(x: rect.midX - rect.width * 0.08, y: rect.height * 0.36),
            control2: CGPoint(x: rect.midX - rect.width * 0.3, y: rect.height * 0.18)
        )
        return path
    }
}
