import Foundation

enum NBAServiceError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case unauthorized
    case rateLimited
    case badStatus(Int)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "No API key found. Add BALLDONTLIE_API_KEY in the target's Info settings."
        case .invalidURL:
            return "The request URL is not valid."
        case .unauthorized:
            return "The API key was rejected, or your plan does not include this endpoint."
        case .rateLimited:
            return "Too many requests. Please wait a minute and try again."
        case .badStatus(let code):
            return "The server returned an error (code \(code))."
        }
    }
}

/// Talks to the BALLDONTLIE NBA API using URLSession and async/await.
struct NBAService {

    /// Fetches players. If `search` is empty, it returns the first page of players.
    func fetchPlayers(search: String) async throws -> [NBAPlayer] {
        let apiKey = APIConfig.apiKey
        guard !apiKey.isEmpty else { throw NBAServiceError.missingAPIKey }

        let path = APIConfig.useActivePlayersEndpoint ? "players/active" : "players"
        guard var components = URLComponents(string: APIConfig.baseURL + path) else {
            throw NBAServiceError.invalidURL
        }

        var queryItems = [URLQueryItem(name: "per_page", value: String(APIConfig.playersPerPage))]

        // The API's "search" parameter matches a first OR last name,
        // so a full name like "Stephen Curry" is split into first_name and last_name.
        let words = search
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .map(String.init)

        if words.count == 1 {
            queryItems.append(URLQueryItem(name: "search", value: words[0]))
        } else if words.count > 1 {
            queryItems.append(URLQueryItem(name: "first_name", value: words[0]))
            queryItems.append(URLQueryItem(name: "last_name", value: words.dropFirst().joined(separator: " ")))
        }
        components.queryItems = queryItems

        guard let url = components.url else { throw NBAServiceError.invalidURL }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            switch http.statusCode {
            case 200...299:
                break
            case 401, 403:
                throw NBAServiceError.unauthorized
            case 429:
                throw NBAServiceError.rateLimited
            default:
                throw NBAServiceError.badStatus(http.statusCode)
            }
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(PlayersResponse.self, from: data).data
    }
}
