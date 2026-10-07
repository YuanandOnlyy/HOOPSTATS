import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BlackjackViewModel()
    @State private var isPressingDeal = false

    var body: some View {
        ZStack {
            LinearGradient.casinoBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    header

                    BalanceCard(balance: viewModel.balance)

                    PlayerSetupView(
                        playerName: $viewModel.playerName,
                        gameMode: $viewModel.gameMode,
                        insuranceEnabled: $viewModel.insuranceEnabled
                    )

                    GameSetupView(
                        betAmount: $viewModel.betAmount,
                        numberOfRounds: $viewModel.numberOfRounds,
                        gameDate: $viewModel.gameDate
                    )

                    dealButton
                        .padding(.top, 4)
                }
                .padding(20)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $viewModel.showResultSheet) {
            if let result = viewModel.sessionResult {
                ResultView(
                    result: result,
                    onNewSession: { viewModel.startNewSession() },
                    onResetBalance: { viewModel.resetBalance() }
                )
            }
        }
        .alert(viewModel.validationMessage ?? "", isPresented: $viewModel.showValidationAlert) {
            Button("OK", role: .cancel) { }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: "suit.spade.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.gold)
                Text("BLACKJACK")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(1)
            }
            Text("VIRTUAL CASINO")
                .font(.system(size: 12, weight: .semibold))
                .tracking(3)
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.top, 8)
    }

    private var dealButton: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                viewModel.dealTheCards()
            }
        } label: {
            HStack {
                Text("DEAL THE CARDS")
                    .font(.system(size: 17, weight: .bold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(LinearGradient.goldButton)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.gold.opacity(0.4), radius: 12, x: 0, y: 6)
            .scaleEffect(isPressingDeal ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressingDeal = true }
                .onEnded { _ in isPressingDeal = false }
        )
    }
}

#Preview {
    ContentView()
}
