import SwiftUI

/// Shared Add / Edit form layout so both sheets look like the rest of the app.
struct PlayerFormContent: View {
    @Binding var name: String
    @Binding var team: String
    @Binding var teamAbbreviation: String
    @Binding var position: String
    @Binding var jerseyNumber: String
    @Binding var pointsText: String
    @Binding var assistsText: String
    @Binding var reboundsText: String
    @Binding var notes: String
    var errorMessage: String?

    private var previewAbbreviation: String {
        let abbreviation = teamAbbreviation.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if !abbreviation.isEmpty { return abbreviation }
        let trimmedTeam = team.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedTeam.isEmpty ? "NBA" : String(trimmedTeam.prefix(3)).uppercased()
    }

    var body: some View {
        Form {
            Section {
                FormPreviewCard(
                    name: name,
                    team: team,
                    abbreviation: previewAbbreviation,
                    jersey: jerseyNumber
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .listRowBackground(Color.clear)
            }

            Section("Player Info") {
                TextField("Full name", text: $name)
                    .textInputAutocapitalization(.words)
                TextField("Team", text: $team)
                TextField("Team Abbreviation", text: $teamAbbreviation)
                    .textInputAutocapitalization(.characters)
                TextField("Position (e.g. G, F, C)", text: $position)
                    .textInputAutocapitalization(.characters)
                TextField("Jersey Number", text: $jerseyNumber)
                    .keyboardType(.numberPad)
            }

            Section {
                HStack(spacing: 10) {
                    HoopStatField(label: "PPG", text: $pointsText)
                    HoopStatField(label: "APG", text: $assistsText)
                    HoopStatField(label: "RPG", text: $reboundsText)
                }
                .listRowBackground(Color.hoopCream)
            } header: {
                Text("Per Game Stats")
            } footer: {
                Text("Enter season averages, for example 26.4. Leave empty for 0.")
            }

            Section("Notes") {
                TextField("Your notes about this player", text: $notes, axis: .vertical)
                    .lineLimit(3...8)
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.red)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .hoopForm()
    }
}
