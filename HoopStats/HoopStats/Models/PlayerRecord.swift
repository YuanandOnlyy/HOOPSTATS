import Foundation
import SwiftData

/// One saved NBA player in the user's personal records.
/// This class is stored on the device using SwiftData.
@Model
final class PlayerRecord {
    /// The player's ID from the BALLDONTLIE API.
    /// Marked unique so the same player cannot be saved twice.
    @Attribute(.unique) var playerID: Int
    var name: String
    var team: String
    var teamAbbreviation: String
    var position: String
    var jerseyNumber: String
    var pointsPerGame: Double
    var assistsPerGame: Double
    var reboundsPerGame: Double
    var notes: String
    var dateSaved: Date

    init(
        playerID: Int,
        name: String,
        team: String,
        teamAbbreviation: String,
        position: String,
        jerseyNumber: String,
        pointsPerGame: Double = 0,
        assistsPerGame: Double = 0,
        reboundsPerGame: Double = 0,
        notes: String = "",
        dateSaved: Date = .now
    ) {
        self.playerID = playerID
        self.name = name
        self.team = team
        self.teamAbbreviation = teamAbbreviation
        self.position = position
        self.jerseyNumber = jerseyNumber
        self.pointsPerGame = pointsPerGame
        self.assistsPerGame = assistsPerGame
        self.reboundsPerGame = reboundsPerGame
        self.notes = notes
        self.dateSaved = dateSaved
    }
}

// Helper values for displaying a record. These are NOT saved in the database.
extension PlayerRecord {
    var jerseyText: String {
        jerseyNumber.isEmpty ? "#—" : "#\(jerseyNumber)"
    }

    var hasStats: Bool {
        pointsPerGame > 0 || assistsPerGame > 0 || reboundsPerGame > 0
    }
}
