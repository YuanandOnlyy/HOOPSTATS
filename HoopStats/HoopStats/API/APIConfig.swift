import Foundation

/// Settings for the BALLDONTLIE NBA API.
///
/// The API key is read from Info.plist (BALLDONTLIE_API_KEY).
enum APIConfig {
    static let baseURL = "https://api.balldontlie.io/v1/"

    /// The free BALLDONTLIE plan only allows GET /players.
    /// Set this to true only if your account plan includes /players/active.
    static let useActivePlayersEndpoint = false

    /// Number of players requested per API call.
    static let playersPerPage = 25

    static var apiKey: String {
        let value = Bundle.main.object(forInfoDictionaryKey: "BALLDONTLIE_API_KEY") as? String ?? ""
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)

        // Treat the placeholder (or an unfilled build variable) as "no key".
        if trimmed == "YOUR_API_KEY" || trimmed.hasPrefix("$(") {
            return ""
        }
        return trimmed
    }
}
