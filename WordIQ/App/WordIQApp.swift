//
//  WordIQApp.swift
//  WordIQ
//
//  Created by Wesley Gore on 10/16/24.
//

import SwiftUI

@main
struct WordIQApp: App {
    
    // @Environment(\.scenePhase) var scenePhase
    let persistenceController = GameDatabasePersistenceController.shared
    
    init() {
        _ = WordDatabaseHelper.shared
        _ = UserDefaultsHelper.shared
        _ = Haptics.shared
        
        // Clear current streak if last daily played is over a day ago
        if let daysSinceEpoch = ValueConverter.daysSince(WordDatabaseHelper.shared.dailyEpoch) {
            if daysSinceEpoch > UserDefaultsHelper.shared.lastDailyPlayed + 1 {
                UserDefaultsHelper.shared.currentStreak_daily = 0
            }
        }

    }

    var body: some Scene {
        WindowGroup {
            AppStartingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
        
//        .onChange(of: scenePhase) {
//            if scenePhase == .inactive {
//                WordDatabaseHelper.shared.closeDatabase()
//            }
//        }
    }
}
