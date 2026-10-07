import SwiftUI

/// A small message that appears at the bottom of the screen and hides itself.
/// Used for "Player saved." and "Changes saved." instead of a popup alert.
struct ToastView: View {
    let message: String

    var body: some View {
        Label(message, systemImage: "checkmark.circle.fill")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                LinearGradient(
                    colors: [Color.hoopNavy, Color.hoopNavyDeep],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .overlay {
                Capsule().stroke(Color.hoopOrange.opacity(0.35), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
    }
}

extension View {
    /// Shows a toast while `message` is not nil, then clears it after 2 seconds.
    func toast(message: Binding<String?>) -> some View {
        overlay(alignment: .bottom) {
            if let text = message.wrappedValue {
                ToastView(message: text)
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: message.wrappedValue)
        .task(id: message.wrappedValue) {
            guard message.wrappedValue != nil else { return }
            try? await Task.sleep(for: .seconds(2))
            message.wrappedValue = nil
        }
    }
}
