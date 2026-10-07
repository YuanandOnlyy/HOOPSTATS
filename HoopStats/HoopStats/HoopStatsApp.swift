import SwiftUI
import SwiftData

@main
struct HoopStatsApp: App {
    // The ModelContainer creates and manages the on-device database
    // where every PlayerRecord is stored.
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: PlayerRecord.self)
        } catch {
            fatalError("Could not create the SwiftData container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Makes the container (and its ModelContext) available to every view.
        .modelContainer(container)
    }
}

