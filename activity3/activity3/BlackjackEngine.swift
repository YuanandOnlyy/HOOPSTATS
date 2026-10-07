import Foundation

struct Hand {
    var cards: [Card] = []

    /// Best blackjack score, treating Aces as 1 or 11 to avoid busting where possible.
    var score: Int {
        var total = cards.reduce(0) { $0 + $1.rank.baseValue }
        var aceCount = cards.filter { $0.isAce }.count
        while total > 21 && aceCount > 0 {
            total -= 10
            aceCount -= 1
        }
        return total
    }

    var isBust: Bool { score > 21 }
    var isBlackjack: Bool { cards.count == 2 && score == 21 }
}

enum RoundOutcome: String {
    case playerBlackjack = "BLACKJACK!"
    case playerWin = "YOU WIN!"
    case dealerWin = "DEALER WINS"
    case push = "PUSH"
    case playerBust = "BUST — DEALER WINS"
    case dealerBust = "DEALER BUSTS — YOU WIN!"
}

enum GameMode: String, CaseIterable, Identifiable {
    case classic = "Classic"
    case quickPlay = "Quick Play"
    case highStakes = "High Stakes"

    var id: String { rawValue }

    /// Multiplier applied to the bet on a player Blackjack in this mode.
    var blackjackPayoutMultiplier: Double {
        switch self {
        case .classic: return 2.5
        case .quickPlay: return 2.5
        case .highStakes: return 3.0
        }
    }
}

/// Core simulation engine: builds a shuffled deck, deals hands, and plays out the dealer
/// according to standard house rules (dealer hits below 17, stands on 17+).
struct BlackjackGame {

    static func freshDeck() -> [Card] {
        var deck: [Card] = []
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                deck.append(Card(rank: rank, suit: suit))
            }
        }
        deck.shuffle()
        return deck
    }

    /// Plays a single complete round and returns both hands, the outcome, and whether
    /// the dealer's up-card was an Ace (relevant for insurance).
    static func playRound() -> (player: Hand, dealer: Hand, outcome: RoundOutcome, dealerShowsAce: Bool) {
        var deck = freshDeck()

        var player = Hand()
        var dealer = Hand()

        player.cards.append(deck.removeLast())
        dealer.cards.append(deck.removeLast())
        player.cards.append(deck.removeLast())
        dealer.cards.append(deck.removeLast())

        let dealerShowsAce = dealer.cards.first?.isAce ?? false

        // Dealer plays automatically: hit below 17, stand at 17 or higher.
        while dealer.score < 17 {
            guard let nextCard = deck.popLast() else { break }
            dealer.cards.append(nextCard)
        }

        let outcome = determineOutcome(player: player, dealer: dealer)

        return (player, dealer, outcome, dealerShowsAce)
    }

    static func determineOutcome(player: Hand, dealer: Hand) -> RoundOutcome {
        if player.isBust {
            return .playerBust
        }
        if player.isBlackjack && dealer.isBlackjack {
            return .push
        }
        if player.isBlackjack {
            return .playerBlackjack
        }
        if dealer.isBlackjack {
            return .dealerWin
        }
        if dealer.isBust {
            return .dealerBust
        }
        if player.score > dealer.score {
            return .playerWin
        }
        if dealer.score > player.score {
            return .dealerWin
        }
        return .push
    }
}
