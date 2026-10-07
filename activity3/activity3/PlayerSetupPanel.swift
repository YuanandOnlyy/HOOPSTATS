import SwiftUI

struct PlayerSetupView: View {
    @Binding var playerName: String
    @Binding var gameMode: GameMode
    @Binding var insuranceEnabled: Bool

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 18) {
                SectionHeader(title: "PLAYER", systemImage: "person.fill")

                VStack(alignment: .leading, spacing: 8) {
                    Text("Player Name")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))

                    TextField(
                        "",
                        text: $playerName,
                        prompt: Text("Enter your name").foregroundColor(.white.opacity(0.3))
                    )
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.casinoSurfaceLight)
                    )
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Game Mode")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))

                    Picker("Game Mode", selection: $gameMode) {
                        ForEach(GameMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Divider().background(Color.white.opacity(0.1))

                VStack(alignment: .leading, spacing: 6) {
                    Toggle(isOn: $insuranceEnabled) {
                        HStack(spacing: 8) {
                            Image(systemName: "shield.lefthalf.filled")
                                .foregroundColor(.gold)
                            Text("Insurance")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                    }
                    .tint(.gold)

                    Text("If enabled and the dealer shows an Ace, a side bet of half your wager is placed automatically. It pays 2:1 if the dealer has Blackjack, otherwise it's lost.")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.45))
                }
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient.casinoBackground.ignoresSafeArea()
        PlayerSetupView(
            playerName: .constant(""),
            gameMode: .constant(.classic),
            insuranceEnabled: .constant(false)
        )
        .padding()
    }
}
