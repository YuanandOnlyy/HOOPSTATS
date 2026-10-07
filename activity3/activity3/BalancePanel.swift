import SwiftUI

struct BalanceCard: View {
    let balance: Double

    var body: some View {
        GlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("VIRTUAL BALANCE")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(1.5)
                        .foregroundColor(.white.opacity(0.6))

                    Text("\(Int(balance)) CR")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.5), value: balance)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(LinearGradient.goldButton)
                        .frame(width: 52, height: 52)
                        .shadow(color: Color.gold.opacity(0.4), radius: 8, x: 0, y: 4)

                    Image(systemName: "banknote.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.black.opacity(0.85))
                }
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient.casinoBackground.ignoresSafeArea()
        BalanceCard(balance: 5000)
            .padding()
    }
}
