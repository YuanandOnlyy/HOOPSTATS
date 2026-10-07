import SwiftUI
import SwiftData

/// Shows one saved player, with Edit (UPDATE) and Delete (DELETE).
struct PlayerDetailView: View {
    let player: PlayerRecord

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    @State private var toastMessage: String?

    private var accent: Color {
        TeamPalette.color(for: player.teamAbbreviation)
    }

    var body: some View {
        Group {
            if player.isDeleted || player.modelContext == nil {
                Color.hoopCourt
            } else {
                details
            }
        }
        .hoopScreen()
        .navigationTitle("Player")
        .navigationBarTitleDisplayMode(.inline)
        .hoopNavBar()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showingEdit = true }
                    .fontWeight(.semibold)
            }
        }
        .sheet(isPresented: $showingEdit) {
            EditPlayerView(player: player) {
                toastMessage = "Changes saved."
            }
        }
        .alert("Delete Player?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) { deletePlayer() }
        } message: {
            Text("This player will be removed from your saved records.")
        }
        .toast(message: $toastMessage)
    }

    private var details: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroCard

                VStack(alignment: .leading, spacing: 12) {
                    Text("Per Game Stats")
                        .font(.headline)
                        .foregroundStyle(Color.hoopInk)
                    HStack(spacing: 10) {
                        StatCard(value: player.pointsPerGame, label: "PPG", accent: .hoopOrange)
                        StatCard(value: player.assistsPerGame, label: "APG", accent: accent)
                        StatCard(value: player.reboundsPerGame, label: "RPG", accent: Color.hoopNavy)
                    }
                    if !player.hasStats {
                        Text("No stats entered yet. Tap Edit to add them.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
                .cardStyle(accent: accent)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)
                        .foregroundStyle(Color.hoopInk)
                    Text(player.notes.isEmpty ? "No notes yet." : player.notes)
                        .font(.body)
                        .foregroundStyle(player.notes.isEmpty ? .secondary : Color.hoopInk)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
                .cardStyle(accent: accent)

                Text("Saved on \(player.dateSaved.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                VStack(spacing: 10) {
                    Button {
                        showingEdit = true
                    } label: {
                        Label("Edit Player", systemImage: "pencil")
                            .font(.body.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.hoopOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete Player", systemImage: "trash")
                            .font(.body.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .padding(16)
        }
    }

    private var heroCard: some View {
        ZStack(alignment: .trailing) {
            Text(player.jerseyNumber.isEmpty ? "#" : player.jerseyText)
                .font(.system(size: 86, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.08))
                .padding(.trailing, 8)

            HStack(spacing: 14) {
                TeamBadge(abbreviation: player.teamAbbreviation, size: 68)
                VStack(alignment: .leading, spacing: 6) {
                    Text(player.name)
                        .font(.title2.weight(.heavy))
                        .foregroundStyle(.white)
                    Text(player.team)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.75))
                    HStack(spacing: 6) {
                        InfoChip(text: player.position.isEmpty ? "N/A" : player.position)
                        InfoChip(text: player.jerseyText)
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [Color.hoopNavyDeep, accent.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: accent.opacity(0.28), radius: 14, y: 8)
    }

    // MARK: - DELETE

    private func deletePlayer() {
        modelContext.delete(player)
        try? modelContext.save()
        dismiss()
    }
}
