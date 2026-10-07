import SwiftUI
import SwiftData

/// UPDATE: edits an existing PlayerRecord. No new object is created.
struct EditPlayerView: View {
    let player: PlayerRecord
    let onSaved: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Local copies of the values. Changes are only written to the
    // record when "Save Changes" is tapped, so Cancel discards them.
    @State private var name: String
    @State private var team: String
    @State private var teamAbbreviation: String
    @State private var position: String
    @State private var jerseyNumber: String
    @State private var pointsText: String
    @State private var assistsText: String
    @State private var reboundsText: String
    @State private var notes: String
    @State private var errorMessage: String?

    init(player: PlayerRecord, onSaved: @escaping () -> Void) {
        self.player = player
        self.onSaved = onSaved
        _name = State(initialValue: player.name)
        _team = State(initialValue: player.team)
        _teamAbbreviation = State(initialValue: player.teamAbbreviation)
        _position = State(initialValue: player.position)
        _jerseyNumber = State(initialValue: player.jerseyNumber)
        _pointsText = State(initialValue: Self.text(for: player.pointsPerGame))
        _assistsText = State(initialValue: Self.text(for: player.assistsPerGame))
        _reboundsText = State(initialValue: Self.text(for: player.reboundsPerGame))
        _notes = State(initialValue: player.notes)
    }

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
            .navigationTitle("Edit Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Changes") { saveChanges() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - UPDATE

    private func saveChanges() {
        guard let points = Self.number(from: pointsText),
              let assists = Self.number(from: assistsText),
              let rebounds = Self.number(from: reboundsText) else {
            errorMessage = "Stats must be numbers between 0 and 100."
            return
        }

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

        // Modify the EXISTING SwiftData object.
        player.name = trimmedName
        player.team = trimmedTeam
        player.teamAbbreviation = teamAbbreviation.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        player.position = position.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        player.jerseyNumber = jerseyNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        player.pointsPerGame = points
        player.assistsPerGame = assists
        player.reboundsPerGame = rebounds
        player.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            try modelContext.save()
            onSaved()
            dismiss()
        } catch {
            errorMessage = "Could not save changes. Please try again."
        }
    }

    // MARK: - Helpers

    private static func text(for value: Double) -> String {
        value == 0 ? "" : String(value)
    }

    /// Converts typed text into a stat. Empty text counts as 0. Returns nil if invalid.
    private static func number(from text: String) -> Double? {
        let cleaned = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        if cleaned.isEmpty { return 0 }
        guard let value = Double(cleaned), value >= 0, value <= 100 else { return nil }
        return value
    }
}
