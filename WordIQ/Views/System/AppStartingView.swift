import SwiftUI

struct AppStartingView: View {
    
    @ObservedObject var navigationController : AppNavigationController
    @ObservedObject var gameModeSelectionVM : GameModeSelectionViewModel
    
    init() {
        self.navigationController = AppNavigationController.shared
        self.gameModeSelectionVM = GameModeSelectionViewModel()
    }
    
    var body: some View {
        ZStack {
            switch navigationController.activeView {
            case .splashScreen:
                SplashScreenView()
                    .transition(.blurReplace)
                    .onAppear {
                        Task {
                            await navigationController.notificationFirstLaunch()
                            navigationController.goToViewWithAnimation(.gameModeSelection, delay: 2.5, pauseLength: 0.5)
                        }
                    }
            case .gameModeSelection:
                GameModeSelectionView(gameModeSelectionVM)
                    .transition(.blurReplace)
            case .singleWordGame:
                SingleWordGameView(gameModeSelectionVM.getSingleWordGameViewModel())
                    .transition(.blurReplace)
            case .fourWordGame:
                FourWordGameView(gameModeSelectionVM.getFourWordGameViewModel())
                    .transition(.blurReplace)
            default:
                Color.appBackground
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    AppStartingView()
}
