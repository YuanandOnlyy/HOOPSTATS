import SwiftUI

struct GameSetupView: View {
    @Binding var betAmount: Double
    @Binding var numberOfRounds: Int
    @Binding var gameDate: Date

    private let betRange: ClosedRange<Double> = 50...1000
    private let betStep: Double = 50

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(title: "GAME SETUP", systemImage: "slider.horizontal.3")

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Virtual Bet")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Text("\(Int(betAmount)) CR")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.gold)
                    }

                    Slider(value: $betAmount, in: betRange, step: betStep)
                        .tint(.gold)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Stepper(value: $numberOfRounds, in: 1...5) {
                        HStack {
                            Text("Rounds")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                            Text("\(numberOfRounds)")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                    .tint(.gold)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Game Date")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))

                    DatePicker("", selection: $gameDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .colorScheme(.dark)
                        .labelsHidden()
                }
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient.casinoBackground.ignoresSafeArea()
        GameSetupView(
            betAmount: .constant(250),
            numberOfRounds: .constant(1),
            gameDate: .constant(Date())
        )
        .padding()
    }
}
