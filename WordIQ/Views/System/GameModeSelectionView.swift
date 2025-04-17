import SwiftUI

/// View for the user to select which game mode they would like to play
struct GameModeSelectionView: View {
    
    @ObservedObject var controller: GameSelectionNavigationController
    @ObservedObject var viewModel: GameModeSelectionViewModel
    
    private let spacing : CGFloat = 8
    
    var body: some View {
        VStack {
            AppHeaderView(viewModel: viewModel)
                .padding(.horizontal)
                .padding(.bottom, 4)

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
                    .padding()
                case .modeOptions:
                    GameModeOptionsView(controller.gameModeOptionsViewModel)
                        .padding(.bottom, 32)
                case .settings:
                    GameSettingsView()
                        .padding()
                case .stats:
                    StatsView()
                default:
                    Color.appBackground
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.appBackground.ignoresSafeArea())
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
