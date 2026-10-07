import SwiftUI
import SwiftData

/// CREATE: adds a new PlayerRecord that you type in yourself.
struct AddPlayerView: View {
    var onSaved: () -> Void = {}

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var savedPlayers: [PlayerRecord]

    @State private var name = ""
    @State private var team = ""
    @State private var teamAbbreviation = ""
    @State private var position = ""
    @State private var jerseyNumber = ""
    @State private var pointsText = ""
    @State private var assistsText = ""
    @State private var reboundsText = ""
    @State private var notes = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            PlayerFormContent(
                name: $name,
                team: $team,
                teamAbbreviation: $teamAbbreviation,
                position: $position,
                jerseyNumber: $jerseyNumber,
                pointsText: $pointsText,
                assistsText: $assistsText,
                reboundsText: $reboundsText,
                notes: $notes,
                errorMessage: errorMessage
            )
            .navigationTitle("Add Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Player") { savePlayer() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - CREATE

    private func savePlayer() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTeam = team.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            errorMessage = "Name cannot be empty."
            return
        }
        guard !trimmedTeam.isEmpty else {
            errorMessage = "Team cannot be empty."
            return
        }
        guard let points = Self.number(from: pointsText),
              let assists = Self.number(from: assistsText),
              let rebounds = Self.number(from: reboundsText) else {
            errorMessage = "Stats must be numbers between 0 and 100."
            return
        }

        var abbreviation = teamAbbreviation.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if abbreviation.isEmpty {
            abbreviation = String(trimmedTeam.prefix(3)).uppercased()
        }

        let record = PlayerRecord(
            playerID: uniqueCustomID(),
            name: trimmedName,
            team: trimmedTeam,
            teamAbbreviation: abbreviation,
            position: position.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(),
            jerseyNumber: jerseyNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            pointsPerGame: points,
            assistsPerGame: assists,
            reboundsPerGame: rebounds,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        modelContext.insert(record)

        do {
            try modelContext.save()
            onSaved()
            dismiss()
        } catch {
            errorMessage = "Could not save player. Please try again."
        }
    }

    /// API players use positive IDs. Custom players use a unique negative ID.
    private func uniqueCustomID() -> Int {
        let existing = Set(savedPlayers.map(\.playerID))
        var id: Int
        repeat {
            id = Int.random(in: Int.min ... -1)
        } while existing.contains(id)
        return id
    }

    private static func number(from text: String) -> Double? {
        let cleaned = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        if cleaned.isEmpty { return 0 }
        guard let value = Double(cleaned), value >= 0, value <= 100 else { return nil }
        return value
    }
}

#Preview {
    AddPlayerView()
        .modelContainer(for: PlayerRecord.self, inMemory: true)
}
