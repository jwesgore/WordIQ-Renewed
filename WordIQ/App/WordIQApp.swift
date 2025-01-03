//
//  WordIQApp.swift
//  WordIQ
//
//  Created by Wesley Gore on 10/16/24.
//

import SwiftUI
import SwiftData

@main
struct WordIQApp: App {
    init() {
        _ = DatabaseHelper.shared
    }
    
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
            SplashScreenView()
        }
        .modelContainer(sharedModelContainer)
    }
}
