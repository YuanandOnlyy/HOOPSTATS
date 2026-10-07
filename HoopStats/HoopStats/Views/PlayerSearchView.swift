import SwiftUI
import SwiftData

/// Explore screen: loads players from the NBA API and lets the user save them.
struct PlayerSearchView: View {
    private enum LoadState {
        case loading
        case loaded
        case failed(String)
    }

    @Environment(\.modelContext) private var modelContext

    // READ: used to know which API players are already saved (prevents duplicates).
    @Query private var savedPlayers: [PlayerRecord]

    @State private var players: [NBAPlayer] = []
    @State private var state: LoadState = .loading
    @State private var searchText = ""
    @State private var toastMessage: String?

    private let service = NBAService()

    private var savedIDs: Set<Int> {
        Set(savedPlayers.map(\.playerID))
    }

    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .hoopScreen()
                .navigationTitle("Explore")
                .hoopNavBar()
                .searchable(text: $searchText, prompt: "Search player name")
                .onSubmit(of: .search) {
                    Task { await loadPlayers() }
                }
                .onChange(of: searchText) { _, newValue in
                    // When the search is cleared, show the default list again.
                    if newValue.isEmpty {
                        Task { await loadPlayers() }
                    }
                }
                .task {
                    // Load once when the screen first appears.
                    if players.isEmpty {
                        await loadPlayers()
                    }
                }
                .toast(message: $toastMessage)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            VStack {
                Spacer()
                HoopLoadingView(message: "Loading the league...")
                Spacer()
            }

        case .failed(let message):
            VStack(spacing: 16) {
                HoopEmptyState(
                    title: "Unable to load NBA players.",
                    systemImage: "wifi.exclamationmark",
                    message: message
                )
                Button {
                    Task { await loadPlayers() }
                } label: {
                    Label("Try Again", systemImage: "arrow.clockwise")
                        .font(.body.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(.hoopOrange)
                .padding(.horizontal, 32)
            }
            .padding(.horizontal, 16)

        case .loaded:
            if players.isEmpty {
                VStack {
                    Spacer()
                    HoopEmptyState(
                        title: "No players found.",
                        systemImage: "person.fill.questionmark",
                        message: "Try a different first or last name."
                    )
                    .padding(.horizontal, 16)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        HStack {
                            Text("SCOUTING REPORT")
                                .font(.caption.weight(.bold))
                                .tracking(1.2)
                                .foregroundStyle(Color.hoopOrange)
                            Spacer()
                            Text("\(players.count)")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.hoopNavy)
                                .clipShape(Capsule())
                        }

                        ForEach(players) { player in
                            PlayerCard(
                                player: player,
                                isSaved: savedIDs.contains(player.id),
                                onSave: { save(player) }
                            )
                        }
                    }
                    .padding(16)
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
    }

    // MARK: - API

    private func loadPlayers() async {
        state = .loading
        do {
            players = try await service.fetchPlayers(search: searchText)
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    // MARK: - CREATE

    /// Creates a new PlayerRecord in SwiftData from an API player.
    /// Stats start at 0 because the free API plan does not return season averages;
    /// the user can enter them later on the Edit screen.
    private func save(_ apiPlayer: NBAPlayer) {
        guard !savedIDs.contains(apiPlayer.id) else {
            toastMessage = "\(apiPlayer.fullName) is already saved."
            return
        }

        let record = PlayerRecord(
            playerID: apiPlayer.id,
            name: apiPlayer.fullName,
            team: apiPlayer.teamName,
            teamAbbreviation: apiPlayer.teamAbbreviation,
            position: apiPlayer.positionText,
            jerseyNumber: apiPlayer.jerseyNumber ?? ""
        )

        modelContext.insert(record)

        do {
            try modelContext.save()
            toastMessage = "Player saved."
        } catch {
            toastMessage = "Could not save player."
        }
    }
}

#Preview {
    PlayerSearchView()
        .modelContainer(for: PlayerRecord.self, inMemory: true)
}
