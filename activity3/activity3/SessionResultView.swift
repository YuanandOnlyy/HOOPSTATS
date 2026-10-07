import SwiftUI

struct ResultView: View {
    let result: SessionResult
    let onNewSession: () -> Void
    let onResetBalance: () -> Void

    private var overallOutcomeSymbol: String {
        if result.totalNetChange > 0 { return "checkmark" }
        if result.totalNetChange < 0 { return "xmark" }
        return "equal"
    }

    private var overallHeadline: String {
        result.rounds.last?.outcome.rawValue ?? "SESSION COMPLETE"
    }

    private var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: result.gameDate)
    }

    private var outcomeColor: Color {
        if result.totalNetChange > 0 { return .green }
        if result.totalNetChange < 0 { return .red }
        return .gold
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(outcomeColor.opacity(0.15))
                            .frame(width: 84, height: 84)
                        Image(systemName: overallOutcomeSymbol)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(outcomeColor)
                    }

                    Text(overallHeadline)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(result.totalNetChange >= 0 ? "+\(Int(result.totalNetChange)) CR" : "\(Int(result.totalNetChange)) CR")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(outcomeColor)
                }
                .padding(.top, 12)
                .transition(.scale.combined(with: .opacity))

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        summaryRow(label: "Player", value: result.playerName)
                        summaryRow(label: "Game Mode", value: result.gameMode.rawValue)
                        summaryRow(label: "Game Date", value: dateFormatted)
                        summaryRow(label: "Bet per Round", value: "\(Int(result.betAmount)) CR")
                        summaryRow(label: "Rounds Played", value: "\(result.rounds.count)")
                        summaryRow(label: "Insurance", value: result.insuranceEnabled ? "Enabled" : "Disabled")
                    }
                }

                VStack(spacing: 14) {
                    ForEach(result.rounds) { round in
                        RoundSummaryCard(round: round)
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "SESSION RESULT", systemImage: "chart.bar.fill")
                        summaryRow(label: "Starting Balance", value: "\(Int(result.startingBalance)) CR")
                        summaryRow(
                            label: "Total Won/Lost",
                            value: result.totalNetChange >= 0 ? "+\(Int(result.totalNetChange)) CR" : "\(Int(result.totalNetChange)) CR",
                            valueColor: outcomeColor
                        )
                        summaryRow(label: "Current Balance", value: "\(Int(result.endingBalance)) CR")
                    }
                }

                VStack(spacing: 12) {
                    Button(action: onNewSession) {
                        Text("NEW SESSION")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(LinearGradient.goldButton)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button(action: onResetBalance) {
                        Text("Reset Balance")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.top, 4)
            }
            .padding(20)
            .padding(.bottom, 20)
        }
        .background(LinearGradient.casinoBackground.ignoresSafeArea())
    }

    private func summaryRow(label: String, value: String, valueColor: Color = .white) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.5))
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(valueColor)
        }
    }
}

struct RoundSummaryCard: View {
    let round: RoundResult

    private var badgeColor: Color {
        switch round.outcome {
        case .playerBlackjack, .playerWin, .dealerBust:
            return .green
        case .dealerWin, .playerBust:
            return .red
        case .push:
            return .gold
        }
    }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("ROUND \(round.roundNumber)")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(1)
                        .foregroundColor(.gold)
                    Spacer()
                    Text(round.outcome.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(badgeColor.opacity(0.25))
                        .clipShape(Capsule())
                }

                HStack(alignment: .top, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PLAYER")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white.opacity(0.4))
                        HandView(cards: round.playerHand.cards)
                        Text("Score: \(round.playerHand.score)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("DEALER")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white.opacity(0.4))
                        HandView(cards: round.dealerHand.cards)
                        Text("Score: \(round.dealerHand.score)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Divider().background(Color.white.opacity(0.1))

                HStack {
                    if round.insurancePayout != 0 {
                        Text(round.insurancePayout > 0 ? "Insurance: +\(Int(round.insurancePayout)) CR" : "Insurance: \(Int(round.insurancePayout)) CR")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Text(round.netChange >= 0 ? "+\(Int(round.netChange)) CR" : "\(Int(round.netChange)) CR")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(round.netChange >= 0 ? .green : .red)
                }
            }
        }
    }
}
