import Foundation

struct RoundResult: Identifiable {
    let id = UUID()
    let roundNumber: Int
    let playerHand: Hand
    let dealerHand: Hand
    let outcome: RoundOutcome
    let bet: Double
    let winnings: Double
    let insurancePayout: Double

    /// Net change to the player's balance from this round, including insurance.
    var netChange: Double {
        winnings + insurancePayout - bet
    }
}

struct SessionResult {
    let playerName: String
    let gameMode: GameMode
    let gameDate: Date
    let betAmount: Double
    let numberOfRounds: Int
    let insuranceEnabled: Bool
    let startingBalance: Double
    let endingBalance: Double
    let rounds: [RoundResult]

    var totalNetChange: Double {
        endingBalance - startingBalance
    }
}
