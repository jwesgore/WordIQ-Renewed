//
//  WordIQApp.swift
//  WordIQ
//
//  Created by Wesley Gore on 10/16/24.
//

import SwiftUI

@main
struct WordIQApp: App {
    
    let persistenceController = GameDatabasePersistenceController.shared
    
    init() {
        _ = WordDatabaseHelper.shared
        _ = UserDefaultsHelper.shared
        _ = Haptics.shared
        
        if let daysSinceEpoch = ValueConverter.daysSince(WordDatabaseHelper.shared.dailyEpoch) {
            if WordDatabaseHelper.shared.fetchDailyWord(dailyId: daysSinceEpoch - 1) == nil {
                UserDefaultsHelper.shared.currentStreak_daily = 0
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        WordDatabaseHelper.shared.closeDatabase()
    }
}
