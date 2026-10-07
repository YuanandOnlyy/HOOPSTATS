import Foundation

enum Suit: String, CaseIterable, Identifiable {
    case hearts = "♥"
    case diamonds = "♦"
    case clubs = "♣"
    case spades = "♠"

    var id: String { rawValue }

    var isRed: Bool {
        self == .hearts || self == .diamonds
    }
}

enum Rank: Int, CaseIterable, Identifiable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king, ace

    var id: Int { rawValue }

    var symbol: String {
        switch self {
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .ten: return "10"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        }
    }

    /// Base blackjack value. Ace defaults to 11 and is adjusted during hand scoring.
    var baseValue: Int {
        switch self {
        case .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten:
            return rawValue
        case .jack, .queen, .king:
            return 10
        case .ace:
            return 11
        }
    }
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let rank: Rank
    let suit: Suit

    var isAce: Bool { rank == .ace }

    var displayName: String {
        "\(rank.symbol)\(suit.rawValue)"
    }
}
