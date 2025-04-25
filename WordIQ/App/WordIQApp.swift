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
        _ = WordDatabaseClient.shared
        _ = UserDefaultsClient.shared
        _ = HapticsHelper.shared
        
        // Clear current streak if last daily played is over a day ago
        if let daysSinceEpoch = ValueConverter.daysSince(WordDatabaseClient.shared.dailyEpoch), daysSinceEpoch > UserDefaultsClient.shared.lastDailyPlayed + 1 {
            UserDefaultsClient.shared.currentStreak_daily = 0
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
                        SDQuadStandardGameResult.self,
                        SDTwentyQuestionsResult.self
                    ])
        }
    }
}
