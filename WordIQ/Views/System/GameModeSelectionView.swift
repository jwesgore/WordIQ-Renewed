import SwiftUI

/// View for the user to select which game mode they would like to play
struct GameModeSelectionView: View {
    
    @ObservedObject var controller: GameSelectionNavigationController
    @ObservedObject var viewModel: GameModeSelectionViewModel
    
    var body: some View {
        VStack {
            AppHeaderView(displayStats: $viewModel.displayStats, displaySettings: $viewModel.displaySettings)
                .padding(.bottom)
            
            ZStack {
                switch controller.activeView {
                case .gameModeSelection:
                    VStack (spacing: 14) {
                        HStack {
                            GameModeButton(viewModel.dailyGameButton, gameMode: .dailyGame)
                            GameModeButton(viewModel.quickplayGameButton, gameMode: .quickplay)
                        }
                        GameModeButton(viewModel.standardGameModeButton, gameMode: .standardMode)
                        GameModeButton(viewModel.rushGameModeButton, gameMode: .rushMode)
                        GameModeButton(viewModel.frenzyGameModeButton, gameMode: .frenzyMode)
                        GameModeButton(viewModel.zenGameModeButton, gameMode: .zenMode)
                        GameModeButton(viewModel.fourWordGameModeButton, gameMode: .quadWordMode)
                        GameModeButton(viewModel.twentyQuestionsGameModeButton, gameMode: .twentyQuestions)
                        
                        Spacer()
                    }
                    .transition(.blurReplace)
                    
                case .gameModeSelectionOptions:
                    GameModeOptionsView(controller.gameModeOptionsViewModel)
                        .transition(.blurReplace)
                    
                default:
                    Color.appBackground
                }
            }
        }
        .padding()
        .background(Color.appBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $viewModel.displaySettings) {
            GameSettingsView(isPresented: $viewModel.displaySettings)
        }
        .fullScreenCover(isPresented: $viewModel.displayStats) {
            StatsView(isPresented: $viewModel.displayStats)
        }
    }
}

/// Simple init
extension GameModeSelectionView {
    init() {
        let controller = AppNavigationController.shared.gameSelectionNavigationController
        self.controller = controller
        self.viewModel = controller.gameModeSelectionViewModel
    }
}
 
#Preview {
    GameModeSelectionView()
}
