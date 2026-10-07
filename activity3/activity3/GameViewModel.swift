import Foundation
import SwiftUI

@MainActor
final class BlackjackViewModel: ObservableObject {

    // MARK: Player setup
    @Published var playerName: String = ""
    @Published var gameMode: GameMode = .classic
    @Published var insuranceEnabled: Bool = false

    // MARK: Game setup
    @Published var betAmount: Double = 250
    @Published var numberOfRounds: Int = 1
    @Published var gameDate: Date = Date()

    // MARK: Balance
    @Published var balance: Double = 5000

    // MARK: Result presentation
    @Published var showResultSheet: Bool = false
    @Published var sessionResult: SessionResult?

    // MARK: Validation
    @Published var validationMessage: String?
    @Published var showValidationAlert: Bool = false

    let startingBalance: Double = 5000
    let minBet: Double = 50
    let maxBet: Double = 1000

    /// Validates input, simulates the requested number of rounds, updates the
    /// virtual balance, and prepares the session result for display.
    func dealTheCards() {
        let trimmedName = playerName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            validationMessage = "Please enter your name."
            showValidationAlert = true
            return
        }

        guard betAmount <= balance else {
            validationMessage = "Insufficient virtual credits."
            showValidationAlert = true
            return
        }

        let sessionStartingBalance = balance
        var roundResults: [RoundResult] = []

        for round in 1...numberOfRounds {
            // Stop simulating further rounds if the balance can no longer cover the bet.
            guard betAmount <= balance else { break }

            let (player, dealer, outcome, dealerShowsAce) = BlackjackGame.playRound()

            var winnings: Double = 0
            switch outcome {
            case .playerBlackjack:
                winnings = betAmount * gameMode.blackjackPayoutMultiplier
            case .playerWin, .dealerBust:
                winnings = betAmount * 2.0
            case .push:
                winnings = betAmount * 1.0
            case .dealerWin, .playerBust:
                winnings = 0
            }

            // Insurance is only offered when the dealer's up-card is an Ace.
            // Cost is half the bet; it pays 2:1 if the dealer has Blackjack, otherwise it's lost.
            var insurancePayout: Double = 0
            if insuranceEnabled && dealerShowsAce {
                let insuranceCost = betAmount * 0.5
                if dealer.isBlackjack {
                    insurancePayout = insuranceCost * 2
                } else {
                    insurancePayout = -insuranceCost
                }
            }

            balance = max(balance - betAmount + winnings + insurancePayout, 0)

            roundResults.append(
                RoundResult(
                    roundNumber: round,
                    playerHand: player,
                    dealerHand: dealer,
                    outcome: outcome,
                    bet: betAmount,
                    winnings: winnings,
                    insurancePayout: insurancePayout
                )
            )
        }

        sessionResult = SessionResult(
            playerName: trimmedName,
            gameMode: gameMode,
            gameDate: gameDate,
            betAmount: betAmount,
            numberOfRounds: numberOfRounds,
            insuranceEnabled: insuranceEnabled,
            startingBalance: sessionStartingBalance,
            endingBalance: balance,
            rounds: roundResults
        )

        showResultSheet = true
    }

    func startNewSession() {
        showResultSheet = false
        sessionResult = nil
    }

    func resetBalance() {
        balance = startingBalance
    }
}
