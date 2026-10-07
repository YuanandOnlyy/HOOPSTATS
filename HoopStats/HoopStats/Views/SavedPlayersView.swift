import SwiftUI
import SwiftData

/// My Players screen: shows every PlayerRecord stored in SwiftData.
struct SavedPlayersView: View {
    @Binding var selectedTab: AppTab

    // READ: SwiftData automatically keeps this array up to date
    // whenever a record is inserted, edited or deleted.
    @Query(sort: \PlayerRecord.dateSaved, order: .reverse) private var players: [PlayerRecord]

    @State private var showingAdd = false
    @State private var toastMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if players.isEmpty {
                    VStack(spacing: 16) {
                        HoopEmptyState(
                            title: "No players saved yet.",
                            systemImage: "star.circle.fill",
                            message: "Add your own player, or save one from the Explore tab."
                        )

                        Button {
                            showingAdd = true
                        } label: {
                            Label("Add Player", systemImage: "plus.circle.fill")
                                .font(.body.weight(.bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.hoopOrange)

                        Button {
                            selectedTab = .explore
                        } label: {
                            Label("Explore Players", systemImage: "magnifyingglass")
                                .font(.body.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.bordered)
                        .tint(.hoopNavy)
                    }
                    .padding(.horizontal, 24)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            HStack {
                                Text("YOUR ROSTER")
                                    .font(.caption.weight(.bold))
                                    .tracking(1.2)
                                    .foregroundStyle(Color.hoopOrange)
                                Spacer()
                                Text("\(players.count) player\(players.count == 1 ? "" : "s")")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.hoopNavy)
                                    .clipShape(Capsule())
                            }

                            ForEach(players) { player in
                                NavigationLink(value: player) {
                                    SavedPlayerCard(player: player)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .hoopScreen()
            .navigationTitle("My Players")
            .hoopNavBar()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Player")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddPlayerView {
                    toastMessage = "Player added."
                }
            }
            .toast(message: $toastMessage)
            .navigationDestination(for: PlayerRecord.self) { player in
                PlayerDetailView(player: player)
            }
        }
    }
}

#Preview {
    SavedPlayersView(selectedTab: .constant(.myPlayers))
        .modelContainer(for: PlayerRecord.self, inMemory: true)
}
