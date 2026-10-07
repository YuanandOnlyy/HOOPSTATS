import SwiftUI

/// Card for a player saved in SwiftData (My Players screen).
struct SavedPlayerCard: View {
    let player: PlayerRecord

    private var accent: Color {
        TeamPalette.color(for: player.teamAbbreviation)
    }

    var body: some View {
        HStack(spacing: 14) {
            TeamBadge(abbreviation: player.teamAbbreviation, size: 52)

            VStack(alignment: .leading, spacing: 6) {
                Text(player.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.hoopInk)
                Text(player.team)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    InfoChip(text: player.position.isEmpty ? "N/A" : player.position)
                    InfoChip(text: player.jerseyText)
                }

                HStack(spacing: 8) {
                    miniStat(player.pointsPerGame, "PPG")
                    miniStat(player.assistsPerGame, "APG")
                    miniStat(player.reboundsPerGame, "RPG")
                }
                .padding(.top, 2)
            }

            Spacer(minLength: 0)

            VStack(spacing: 10) {
                Text(player.jerseyText)
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(accent.opacity(0.35))
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(Color.hoopOrange.opacity(0.7))
            }
        }
        .padding(16)
        .cardStyle(accent: accent)
    }

    private func miniStat(_ value: Double, _ label: String) -> some View {
        VStack(spacing: 1) {
            Text(value > 0 ? value.formatted(.number.precision(.fractionLength(1))) : "—")
                .font(.caption.weight(.heavy).monospacedDigit())
                .foregroundStyle(Color.hoopInk)
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(minWidth: 36)
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(Color.hoopCourt)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
