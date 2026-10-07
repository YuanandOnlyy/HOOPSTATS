import SwiftUI

/// One statistic box, e.g. "27.3" over "PPG".
struct StatCard: View {
    let value: Double
    let label: String
    var accent: Color = .hoopOrange

    var body: some View {
        VStack(spacing: 6) {
            Text(value > 0 ? value.formatted(.number.precision(.fractionLength(1))) : "—")
                .font(.title.weight(.heavy).monospacedDigit())
                .foregroundStyle(Color.hoopInk)
            Text(label)
                .font(.caption.weight(.bold))
                .tracking(0.6)
                .foregroundStyle(accent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.hoopCourt)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(alignment: .top) {
            Capsule()
                .fill(accent)
                .frame(width: 28, height: 4)
                .padding(.top, 8)
        }
    }
}

#Preview {
    HStack {
        StatCard(value: 26.4, label: "PPG")
        StatCard(value: 6.1, label: "APG")
        StatCard(value: 0, label: "RPG")
    }
    .padding()
}
