//
//  WordIQApp.swift
//  WordIQ
//
//  Created by Wesley Gore on 10/16/24.
//

import SwiftUI
// import FirebaseCore

@main
struct WordIQApp: App {
    
    // @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = GameDatabasePersistenceController.shared
    
    init() {
        _ = WordDatabaseHelper.shared
        _ = UserDefaultsHelper.shared
        _ = HapticsHelper.shared
        
        // Clear current streak if last daily played is over a day ago
        if let daysSinceEpoch = ValueConverter.daysSince(WordDatabaseHelper.shared.dailyEpoch), daysSinceEpoch > UserDefaultsHelper.shared.lastDailyPlayed + 1 {
            UserDefaultsHelper.shared.currentStreak_daily = 0
        }

    }

    var body: some Scene {
        WindowGroup {
            AppStartingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
