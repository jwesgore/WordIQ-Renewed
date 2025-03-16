import SwiftUI

struct GameModeButton: View {
    
    @ObservedObject var threeDButtonVM : ThreeDButtonViewModel
    
    let title : String
    var caption: String
    
    var body: some View {
        ThreeDButtonView(threeDButtonVM) {
            VStack {
                Text(title)
                    .font(.custom(RobotoSlabOptions.Weight.bold, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
                Text(caption)
                    .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.caption)))
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
        default:
            self.caption = gameMode.caption
        }
    }
}
