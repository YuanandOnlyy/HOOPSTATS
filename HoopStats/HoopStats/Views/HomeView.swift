import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var selectedTab: AppTab

    @Query(sort: \PlayerRecord.dateSaved, order: .reverse) private var savedPlayers: [PlayerRecord]

    @State private var showingAdd = false
    @State private var toastMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    summaryCard
                    actionButtons
                    recentSection
                }
                .padding(16)
            }
        }
        .hoopScreen()
        .sheet(isPresented: $showingAdd) {
            AddPlayerView {
                toastMessage = "Player added."
            }
        }
        .toast(message: $toastMessage)
    }

    // MARK: - Sections

    private var header: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(systemName: "basketball.fill")
                .font(.system(size: 132))
                .foregroundStyle(.white.opacity(0.07))
                .offset(x: 36, y: 18)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Image(systemName: "basketball.fill")
                        .font(.title2)
                        .foregroundStyle(Color.hoopOrange)
                        .frame(width: 38, height: 38)
                        .background(Color.hoopOrange.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    Text("HOOPSTATS")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .tracking(1.4)
                        .foregroundStyle(.white)
                }

                Text("NBA PLAYER RECORDS")
                    .font(.caption.weight(.bold))
                    .tracking(1.6)
                    .foregroundStyle(Color.hoopOrange)

                Text("Scout the league, add your own players, and keep a personal stat book.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.82))
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 36)
        }
        .background {
            LinearGradient(
                colors: [Color.hoopNavyDeep, Color.hoopNavy],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(HeaderWave())
            .ignoresSafeArea(edges: .top)
        }
        .overlay(alignment: .bottom) {
            Capsule()
                .fill(Color.hoopOrange)
                .frame(width: 48, height: 4)
                .offset(y: -10)
        }
    }

    private var summaryCard: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("YOUR ROSTER")
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.hoopOrange)
                Text("\(savedPlayers.count)")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.hoopInk)
                Text(savedPlayers.count == 1 ? "saved player" : "saved players")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            ZStack {
                Image(systemName: "star.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color.hoopOrange, Color.hoopOrange.opacity(0.75)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Color.hoopOrange.opacity(0.4), radius: 8, y: 4)

                if !savedPlayers.isEmpty {
                    HStack(spacing: -6) {
                        ForEach(Array(savedPlayers.prefix(3).enumerated()), id: \.element.id) { _, player in
                            Circle()
                                .fill(TeamPalette.color(for: player.teamAbbreviation))
                                .frame(width: 14, height: 14)
                                .overlay(Circle().stroke(Color.hoopCream, lineWidth: 2))
                        }
                    }
                    .offset(y: 34)
                }
            }
            .padding(.bottom, savedPlayers.isEmpty ? 0 : 10)
        }
        .padding(18)
        .cardStyle()
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                HoopActionTile(
                    title: "Explore",
                    subtitle: "Search the NBA",
                    systemImage: "magnifyingglass",
                    emphasized: true
                ) {
                    selectedTab = .explore
                }

                HoopActionTile(
                    title: "My Players",
                    subtitle: "View records",
                    systemImage: "person.2.fill"
                ) {
                    selectedTab = .myPlayers
                }
            }

            HoopActionTile(
                title: "Add Your Own Player",
                subtitle: "Create a custom record",
                systemImage: "plus.circle.fill"
            ) {
                showingAdd = true
            }
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recently Saved")
                    .font(.headline)
                    .foregroundStyle(Color.hoopInk)
                Spacer()
                if !savedPlayers.isEmpty {
                    Button("See all") {
                        selectedTab = .myPlayers
                    }
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.hoopOrange)
                }
            }

            if savedPlayers.isEmpty {
                HoopEmptyState(
                    title: "Your bench is empty.",
                    systemImage: "clipboard",
                    message: "Add a custom player or save one from Explore."
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(savedPlayers.prefix(3).enumerated()), id: \.element.id) { index, player in
                        Button {
                            selectedTab = .myPlayers
                        } label: {
                            HStack(spacing: 12) {
                                TeamBadge(abbreviation: player.teamAbbreviation, size: 40)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(player.name)
                                        .font(.subheadline.weight(.bold))
                                        .foregroundStyle(Color.hoopInk)
                                    Text("\(player.position.isEmpty ? "N/A" : player.position) • \(player.jerseyText)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(player.dateSaved, format: .dateTime.month(.abbreviated).day())
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(Color.hoopOrange)
                                    Image(systemName: "chevron.right")
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(Color.hoopNavy.opacity(0.25))
                                }
                            }
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)

                        if index < min(2, savedPlayers.count - 1) {
                            Divider().overlay(Color.hoopNavy.opacity(0.08))
                        }
                    }
                }
                .padding(.horizontal, 14)
                .cardStyle()
            }
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
        .modelContainer(for: PlayerRecord.self, inMemory: true)
}
