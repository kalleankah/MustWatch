//
//  MustWatchApp.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-19.
//

import SwiftUI
import SwiftData

@main
struct MustWatchApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TitleModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LandingTabView()
                .modelContainer(sharedModelContainer)
        }
    }
}
