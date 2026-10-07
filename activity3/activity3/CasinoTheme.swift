import SwiftUI

extension Color {
    static let gold = Color(red: 0.83, green: 0.68, blue: 0.21)
    static let goldLight = Color(red: 0.95, green: 0.82, blue: 0.45)
    static let casinoBackground = Color(red: 0.05, green: 0.05, blue: 0.07)
    static let casinoSurface = Color(red: 0.11, green: 0.11, blue: 0.14)
    static let casinoSurfaceLight = Color(red: 0.16, green: 0.16, blue: 0.20)
}

extension LinearGradient {
    static let goldButton = LinearGradient(
        colors: [Color.goldLight, Color.gold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let casinoBackground = LinearGradient(
        colors: [Color(red: 0.07, green: 0.07, blue: 0.10), Color(red: 0.02, green: 0.02, blue: 0.03)],
        startPoint: .top,
        endPoint: .bottom
    )
}

/// Reusable glass-like card container used throughout the app.
struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.casinoSurface.opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 6)
    }
}

struct SectionHeader: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundColor(.gold)
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .tracking(1.5)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
        }
    }
}
