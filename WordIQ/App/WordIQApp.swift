//
//  WordIQApp.swift
//  WordIQ
//
//  Created by Wesley Gore on 10/16/24.
//

import SwiftUI

@main
struct WordIQApp: App {

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
                .modelContainer(for: [
                        SDStandardGameResult.self,
                        SDRushGameResult.self,
                        SDFrenzyGameResult.self,
                        SDDailyGameResult.self,
                        SDZenGameResult.self,
                        SDQuadStandardGameResult.self
                    ])
        }
    }
}
