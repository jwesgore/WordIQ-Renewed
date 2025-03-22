import SwiftUI

struct GameModeButton: View {
    
    @ObservedObject var threeDButtonVM : ThreeDButtonViewModel
    
    let title : String
    var caption: String
    
    var body: some View {
        ThreeDButtonView(threeDButtonVM) {
            VStack {
                Text(title)
                    .robotoSlabFont(.title2, .bold)
                Text(caption)
                    .robotoSlabFont(.caption, .regular)
                    .opacity(0.6)
            }
        }
    }
}

extension GameModeButton {
    init(_ threeDButtonVM: ThreeDButtonViewModel, gameMode: GameMode) {
        self.threeDButtonVM = threeDButtonVM
        self.title = gameMode.asStringShort
        
        switch gameMode {
        case .dailyGame:
            self.caption = gameMode.caption
            
            if let daysSinceEpoch = ValueConverter.daysSince(WordDatabaseHelper.shared.dailyEpoch) {
                let lastDailyPlayed = UserDefaultsHelper.shared.lastDailyPlayed
                
                if lastDailyPlayed == daysSinceEpoch {
                    let lastDailyPlayedResults = UserDefaultsHelper.shared.dailyGameOverModel
                    
                    if let lastDailyPlayedResults {
                        if lastDailyPlayedResults.gameResult == .lose {
                            self.caption = "Better luck tomorrow :("
                        } else {
                            self.caption = "You solved it in \(lastDailyPlayedResults.numValidGuesses) guesses!"
                        }
                    }
                } else if lastDailyPlayed > daysSinceEpoch {
                    self.caption = "Error! Time traveler detected!"
                }
            }
        case .quickplay:
            self.caption = "\(UserDefaultsHelper.shared.quickplaySetting_mode.asStringShort), \(UserDefaultsHelper.shared.quickplaySetting_difficulty.asString)"
            
            if UserDefaultsHelper.shared.quickplaySetting_mode == .rushMode || UserDefaultsHelper.shared.quickplaySetting_mode == .frenzyMode {
                self.caption += ", \(TimeUtility.formatTimeShort(UserDefaultsHelper.shared.quickplaySetting_timeLimit))"
            }
        default:
            self.caption = gameMode.caption
        }
    }
}
