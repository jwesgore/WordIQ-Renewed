import SwiftUI

/// View for the user to select which game mode they would like to play
struct GameModeSelectionView: View {
    
    @ObservedObject var controller: GameSelectionNavigationController
    @ObservedObject var viewModel: GameModeSelectionViewModel
    
    private let spacing : CGFloat = 10
    
    var body: some View {
        VStack {
            AppHeaderView(viewModel: viewModel, displayStats: $viewModel.displayStats, displaySettings: $viewModel.displaySettings)
                .padding(.bottom)
            
            ZStack {
                switch controller.activeView {
                case .modeSelection:
                    VStack (spacing: spacing) {
                        
                        HStack (spacing: spacing) {
                            GameModeButton(viewModel.dailyGameButton, gameMode: .dailyGame)
                            GameModeButton(viewModel.quickplayGameButton, gameMode: .quickplay)
                        }
                        HStack (spacing: spacing) {
                            GameModeButton(viewModel.standardGameModeButton, gameMode: .standardMode)
                            GameModeButton(viewModel.rushGameModeButton, gameMode: .rushMode)
                        }
                        HStack (spacing: spacing) {
                            GameModeButton(viewModel.frenzyGameModeButton, gameMode: .frenzyMode)
                            GameModeButton(viewModel.zenGameModeButton, gameMode: .zenMode)
                        }
                        HStack (spacing: spacing) {
                            GameModeButton(viewModel.fourWordGameModeButton, gameMode: .quadWordMode)
                            GameModeButton(viewModel.twentyQuestionsGameModeButton, gameMode: .twentyQuestions)
                        }
                        
                        Spacer()
                    }
                    .transition(.blurReplace)
                    
                case .modeOptions:
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
