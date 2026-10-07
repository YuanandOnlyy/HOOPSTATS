import SwiftUI

/// Card for a player returned by the NBA API (Explore screen).
struct PlayerCard: View {
    let player: NBAPlayer
    let isSaved: Bool
    let onSave: () -> Void

    private var accent: Color {
        TeamPalette.color(for: player.teamAbbreviation)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                TeamBadge(abbreviation: player.teamAbbreviation)

                VStack(alignment: .leading, spacing: 6) {
                    Text(player.fullName)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.hoopInk)
                    Text(player.teamName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 6) {
                        InfoChip(text: player.positionText)
                        InfoChip(text: player.jerseyText)
                    }
                }

                Spacer(minLength: 0)

                Text(player.jerseyText)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(accent.opacity(0.18))
            }

            Divider().overlay(Color.hoopNavy.opacity(0.08))

            HStack(alignment: .center) {
                Label(
                    player.detailsText.isEmpty ? "No extra details" : player.detailsText,
                    systemImage: "figure.basketball"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

                Spacer(minLength: 8)

                if isSaved {
                    Label("Saved", systemImage: "checkmark.circle.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(accent)
                        .clipShape(Capsule())
                } else {
                    Button(action: onSave) {
                        Label("Save", systemImage: "plus")
                            .font(.caption.weight(.bold))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.hoopOrange)
                    .controlSize(.small)
                }
            }
        }
        .padding(16)
        .cardStyle(accent: accent)
    }
}
