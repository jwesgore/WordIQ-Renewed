import SwiftUI

struct AppStartingView: View {
    
    @ObservedObject var controller = AppNavigationController.shared
    
    var body: some View {
        ZStack {
            switch controller.activeView {
            case .splashScreen:
                SplashScreenView()
                    .transition(.blurReplace)
                    .onAppear {
                        Task {
                            await controller.notificationFirstLaunch()
                            controller.goToViewWithAnimation(.gameModeSelection, delay: 2.5, pauseLength: 0.5)
                        }
                    }
            case .gameModeSelection:
                GameModeSelectionView(controller.gameModeSelectionViewModel)
                    .transition(.blurReplace)
            case .singleWordGame:
                SingleWordGameView()
                    .transition(.opacity)
            case .fourWordGame:
                FourWordGameView(controller.fourWordGameViewModel)
                    .transition(.opacity)
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
