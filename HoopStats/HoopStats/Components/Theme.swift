import SwiftUI

extension Color {
    static let hoopOrange = Color(red: 0.96, green: 0.42, blue: 0.10)
    static let hoopNavy = Color(red: 0.07, green: 0.10, blue: 0.20)
    static let hoopNavyDeep = Color(red: 0.04, green: 0.06, blue: 0.13)
    static let hoopCourt = Color(red: 0.96, green: 0.94, blue: 0.90)
    static let hoopCream = Color(red: 1.0, green: 0.99, blue: 0.97)
    static let hoopInk = Color(red: 0.12, green: 0.13, blue: 0.18)
}

enum TeamPalette {
    static func color(for abbreviation: String) -> Color {
        switch abbreviation.uppercased() {
        case "ATL": Color(red: 0.88, green: 0.15, blue: 0.16)
        case "BOS": Color(red: 0.00, green: 0.48, blue: 0.19)
        case "BKN": Color(red: 0.18, green: 0.18, blue: 0.20)
        case "CHA": Color(red: 0.11, green: 0.55, blue: 0.65)
        case "CHI": Color(red: 0.81, green: 0.07, blue: 0.15)
        case "CLE": Color(red: 0.52, green: 0.09, blue: 0.18)
        case "DAL": Color(red: 0.00, green: 0.33, blue: 0.65)
        case "DEN": Color(red: 0.13, green: 0.22, blue: 0.45)
        case "DET": Color(red: 0.78, green: 0.14, blue: 0.21)
        case "GSW": Color(red: 0.12, green: 0.35, blue: 0.69)
        case "HOU": Color(red: 0.81, green: 0.18, blue: 0.22)
        case "IND": Color(red: 0.00, green: 0.29, blue: 0.37)
        case "LAC": Color(red: 0.78, green: 0.06, blue: 0.18)
        case "LAL": Color(red: 0.33, green: 0.16, blue: 0.55)
        case "MEM": Color(red: 0.36, green: 0.51, blue: 0.69)
        case "MIA": Color(red: 0.58, green: 0.13, blue: 0.22)
        case "MIL": Color(red: 0.00, green: 0.28, blue: 0.18)
        case "MIN": Color(red: 0.04, green: 0.17, blue: 0.33)
        case "NOP": Color(red: 0.00, green: 0.17, blue: 0.30)
        case "NYK": Color(red: 0.00, green: 0.33, blue: 0.62)
        case "OKC": Color(red: 0.00, green: 0.49, blue: 0.76)
        case "ORL": Color(red: 0.00, green: 0.44, blue: 0.72)
        case "PHI": Color(red: 0.00, green: 0.42, blue: 0.69)
        case "PHX": Color(red: 0.90, green: 0.35, blue: 0.10)
        case "POR": Color(red: 0.88, green: 0.13, blue: 0.20)
        case "SAC": Color(red: 0.36, green: 0.18, blue: 0.57)
        case "SAS": Color(red: 0.38, green: 0.40, blue: 0.43)
        case "TOR": Color(red: 0.81, green: 0.14, blue: 0.19)
        case "UTA": Color(red: 0.00, green: 0.27, blue: 0.40)
        case "WAS": Color(red: 0.00, green: 0.24, blue: 0.53)
        default: Color.hoopNavy
        }
    }
}

struct CourtBackground: View {
    var body: some View {
        ZStack {
            Color.hoopCourt
            Canvas { context, size in
                var line = context
                line.opacity = 0.10
                var path = Path()
                let midX = size.width / 2
                path.addEllipse(in: CGRect(x: midX - 70, y: size.height * 0.18, width: 140, height: 140))
                path.move(to: CGPoint(x: 24, y: 0))
                path.addLine(to: CGPoint(x: 24, y: size.height))
                path.move(to: CGPoint(x: size.width - 24, y: 0))
                path.addLine(to: CGPoint(x: size.width - 24, y: size.height))
                path.addEllipse(in: CGRect(x: midX - 110, y: size.height - 90, width: 220, height: 180))
                line.stroke(
                    path,
                    with: .color(.hoopNavy),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
            }
        }
        .ignoresSafeArea()
    }
}

struct CardBackground: ViewModifier {
    var accent: Color = .hoopOrange

    func body(content: Content) -> some View {
        content
            .background(Color.hoopCream)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(alignment: .leading) {
                UnevenRoundedRectangle(
                    topLeadingRadius: 18,
                    bottomLeadingRadius: 18,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0,
                    style: .continuous
                )
                .fill(accent)
                .frame(width: 5)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.hoopNavy.opacity(0.06), lineWidth: 1)
            }
            .shadow(color: Color.hoopNavy.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

struct HeaderWave: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 22))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - 22),
            control: CGPoint(x: rect.width / 2, y: rect.height + 8)
        )
        path.closeSubpath()
        return path
    }
}

struct HoopEmptyState: View {
    let title: String
    let systemImage: String
    let message: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(Color.hoopOrange)
                .frame(width: 76, height: 76)
                .background(Color.hoopOrange.opacity(0.12))
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.hoopOrange.opacity(0.25), lineWidth: 1)
                }

            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(Color.hoopInk)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .cardStyle()
    }
}

struct HoopLoadingView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.hoopOrange)
                .scaleEffect(1.2)
            Text(message)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.hoopInk)
        }
        .padding(28)
        .cardStyle()
        .padding(.horizontal, 32)
    }
}

struct FormPreviewCard: View {
    let name: String
    let team: String
    let abbreviation: String
    let jersey: String

    var body: some View {
        ZStack(alignment: .trailing) {
            Text(jersey.isEmpty ? "#" : "#\(jersey)")
                .font(.system(size: 64, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.10))
                .padding(.trailing, 6)

            HStack(spacing: 14) {
                TeamBadge(abbreviation: abbreviation.isEmpty ? "NBA" : abbreviation, size: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text(name.isEmpty ? "New Player" : name)
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(.white)
                    Text(team.isEmpty ? "Choose a team" : team)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.75))
                }
                Spacer(minLength: 0)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.hoopNavyDeep, TeamPalette.color(for: abbreviation)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct HoopStatField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.hoopOrange)
            TextField("0.0", text: $text)
                .keyboardType(.decimalPad)
                .font(.title3.weight(.heavy).monospacedDigit())
                .foregroundStyle(Color.hoopInk)
                .padding(10)
                .background(Color.hoopCourt)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func cardStyle(accent: Color = .hoopOrange) -> some View {
        modifier(CardBackground(accent: accent))
    }

    func hoopScreen() -> some View {
        background(CourtBackground())
    }

    func hoopNavBar() -> some View {
        toolbarBackground(Color.hoopNavy, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }

    func hoopForm() -> some View {
        scrollContentBackground(.hidden)
            .background(Color.hoopCourt)
            .tint(.hoopOrange)
            .hoopNavBar()
    }
}

struct TeamBadge: View {
    let abbreviation: String
    var size: CGFloat = 48

    private var teamColor: Color {
        TeamPalette.color(for: abbreviation)
    }

    var body: some View {
        Text(abbreviation.isEmpty ? "FA" : abbreviation)
            .font(.system(size: size * 0.28, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .frame(width: size, height: size)
            .background(
                LinearGradient(
                    colors: [teamColor, teamColor.opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                    .stroke(.white.opacity(0.25), lineWidth: 1)
            }
            .shadow(color: teamColor.opacity(0.35), radius: 6, y: 3)
    }
}

struct InfoChip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.bold))
            .foregroundStyle(Color.hoopOrange)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.hoopOrange.opacity(0.12))
            .clipShape(Capsule())
    }
}

struct HoopActionTile: View {
    let title: String
    let subtitle: String
    let systemImage: String
    var emphasized: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(emphasized ? .white : Color.hoopOrange)
                    .frame(width: 36, height: 36)
                    .background(emphasized ? Color.white.opacity(0.18) : Color.hoopOrange.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(emphasized ? .white : Color.hoopInk)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(emphasized ? .white.opacity(0.8) : .secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(
                Group {
                    if emphasized {
                        LinearGradient(
                            colors: [Color.hoopOrange, Color.hoopOrange.opacity(0.82)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color.hoopCream
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(emphasized ? Color.clear : Color.hoopNavy.opacity(0.06), lineWidth: 1)
            }
            .shadow(color: Color.hoopNavy.opacity(emphasized ? 0.18 : 0.07), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
    }
}
