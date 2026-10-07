import SwiftUI

struct PlayingCardView: View {
    let rank: Rank?
    let suit: Suit?
    var isHidden: Bool = false

    private let cardWidth: CGFloat = 64
    private let cardHeight: CGFloat = 92

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isHidden ? AnyShapeStyle(cardBackGradient) : AnyShapeStyle(Color.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.35), radius: 4, x: 0, y: 3)

            if isHidden {
                Image(systemName: "suit.spade.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color.gold.opacity(0.85))
            } else if let rank, let suit {
                VStack(spacing: 0) {
                    HStack {
                        VStack(spacing: 0) {
                            Text(rank.symbol)
                                .font(.system(size: 15, weight: .bold))
                            Text(suit.rawValue)
                                .font(.system(size: 13))
                        }
                        .foregroundColor(suit.isRed ? .red : .black)
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    .padding(.top, 6)

                    Spacer()

                    Text(suit.rawValue)
                        .font(.system(size: 26))
                        .foregroundColor(suit.isRed ? .red : .black)

                    Spacer()

                    HStack {
                        Spacer()
                        VStack(spacing: 0) {
                            Text(suit.rawValue)
                                .font(.system(size: 13))
                            Text(rank.symbol)
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundColor(suit.isRed ? .red : .black)
                    }
                    .padding(.horizontal, 6)
                    .padding(.bottom, 6)
                }
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .transition(.scale.combined(with: .opacity))
    }

    private var cardBackGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.1, green: 0.15, blue: 0.35), Color(red: 0.05, green: 0.08, blue: 0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct HandView: View {
    let cards: [Card]
    var hideFirstCard: Bool = false

    var body: some View {
        HStack(spacing: -20) {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                PlayingCardView(
                    rank: card.rank,
                    suit: card.suit,
                    isHidden: hideFirstCard && index == 0
                )
                .zIndex(Double(index))
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HandView(cards: [
            Card(rank: .ace, suit: .spades),
            Card(rank: .king, suit: .hearts)
        ])
    }
}
