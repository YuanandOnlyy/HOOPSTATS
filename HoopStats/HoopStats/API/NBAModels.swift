import Foundation

// These structs match the JSON returned by the BALLDONTLIE API.
// They are only used to display API results. They are NOT stored in SwiftData.

/// Top-level response from GET /players.
struct PlayersResponse: Decodable {
    let data: [NBAPlayer]
}

struct NBATeam: Decodable {
    let id: Int
    let abbreviation: String
    let city: String
    let name: String
    let fullName: String
}

struct NBAPlayer: Decodable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let position: String?
    let height: String?
    let weight: String?
    let jerseyNumber: String?
    let college: String?
    let team: NBATeam?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, position, height, weight, jerseyNumber, college, team
    }

    // Custom decoding so a missing or differently-typed field
    // (for example a jersey number sent as a number) does not break the whole list.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        position = try? container.decodeIfPresent(String.self, forKey: .position)
        height = try? container.decodeIfPresent(String.self, forKey: .height)
        weight = try? container.decodeIfPresent(String.self, forKey: .weight)
        college = try? container.decodeIfPresent(String.self, forKey: .college)
        team = try? container.decodeIfPresent(NBATeam.self, forKey: .team)

        if let text = try? container.decodeIfPresent(String.self, forKey: .jerseyNumber) {
            jerseyNumber = text
        } else if let number = try? container.decodeIfPresent(Int.self, forKey: .jerseyNumber) {
            jerseyNumber = String(number)
        } else {
            jerseyNumber = nil
        }
    }
}

// Helper text used by the views.
extension NBAPlayer {
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    var teamName: String {
        team?.fullName ?? "Free Agent"
    }

    var teamAbbreviation: String {
        team?.abbreviation ?? "FA"
    }

    var positionText: String {
        guard let position, !position.isEmpty else { return "N/A" }
        return position
    }

    var jerseyText: String {
        guard let jerseyNumber, !jerseyNumber.isEmpty else { return "#—" }
        return "#\(jerseyNumber)"
    }

    /// Small line of real API details, e.g. "6-2 • 185 lbs • Davidson".
    var detailsText: String {
        var parts: [String] = []
        if let height, !height.isEmpty { parts.append(height) }
        if let weight, !weight.isEmpty { parts.append("\(weight) lbs") }
        if let college, !college.isEmpty { parts.append(college) }
        return parts.joined(separator: " • ")
    }
}
