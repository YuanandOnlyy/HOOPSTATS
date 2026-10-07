import SwiftUI
import SwiftData
import UIKit

/// The three tabs of the app.
enum AppTab: Hashable {
    case home
    case explore
    case myPlayers
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 1.0, green: 0.99, blue: 0.97, alpha: 1)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.96, green: 0.42, blue: 0.10, alpha: 1)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.96, green: 0.42, blue: 0.10, alpha: 1)
        ]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(AppTab.home)

            PlayerSearchView()
                .tabItem { Label("Explore", systemImage: "basketball.fill") }
                .tag(AppTab.explore)

            SavedPlayersView(selectedTab: $selectedTab)
                .tabItem { Label("My Players", systemImage: "star.fill") }
                .tag(AppTab.myPlayers)
        }
        .tint(.hoopOrange)
        .toolbarBackground(Color.hoopCream, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: PlayerRecord.self, inMemory: true)
}

