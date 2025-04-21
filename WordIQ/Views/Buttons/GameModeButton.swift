import SwiftUI

/// Button for selecting which game mode
struct GameModeButton: View {
    
    @ObservedObject var viewModel : TopDownButtonViewModel
    
    let title : String
    var caption: String
    
    var body: some View {
        
        TopDownButton(viewModel) {
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
    init(_ viewModel: TopDownButtonViewModel, gameMode: GameMode) {
        self.viewModel = viewModel
        self.title = gameMode.asStringShort
        
        switch gameMode {
        case .dailyGame:
            self.caption = gameMode.caption
            
            if let daysSinceEpoch = ValueConverter.daysSince(WordDatabaseClient.shared.dailyEpoch) {
                let lastDailyPlayed = UserDefaultsClient.shared.lastDailyPlayed
                
                if lastDailyPlayed == daysSinceEpoch {
                    let lastDailyPlayedResults = UserDefaultsClient.shared.dailyGameOverModel
                    
                    if let lastDailyPlayedResults {
                        if lastDailyPlayedResults.gameResult == .lose {
                            self.caption = "Better luck tomorrow :("
                        } else {
                            self.caption = "You solved it in \(lastDailyPlayedResults.numberOfValidGuesses) guesses!"
                        }
                    }
                } else if lastDailyPlayed > daysSinceEpoch {
                    self.caption = "Error! Time traveler detected!"
                }
            }
        case .quickplay:
            self.caption = "\(UserDefaultsClient.shared.quickplaySetting_mode.asStringShort), \(UserDefaultsClient.shared.quickplaySetting_difficulty.asString)"
            
            if UserDefaultsClient.shared.quickplaySetting_mode == .rushMode || UserDefaultsClient.shared.quickplaySetting_mode == .frenzyMode {
                self.caption += ", \(TimeUtility.formatTimeShort(UserDefaultsClient.shared.quickplaySetting_timeLimit))"
            }
        default:
            self.caption = gameMode.caption
        }
    }
}
