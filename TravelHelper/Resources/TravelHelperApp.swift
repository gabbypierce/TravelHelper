//
//  TravelHelperApp.swift
//  TravelHelper
//
//  Created by Gabby Pierce on 2/12/24.
//

import SwiftUI
import SwiftData

@main
struct TravelHelperApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            TravelView()
        }
        .modelContainer(sharedModelContainer)
    }
}
