import SwiftUI

/// Navigation Controller for single word game view
class SingleWordGameNavigationController : NavigationControllerBase {
    
    var gameOptions: SingleWordGameModeOptionsModel {
        return AppNavigationController.shared.singleWordGameModeOptionsModel
    }
    
    init() {
        super.init(.singleWordGame)
    }
    
    /// Entry point for AppNavigationController to start game
    func startGame(complete: @escaping () -> Void = {}) {
        goToGameView(immediate: true) {
            complete()
        }
    }
    
    /// Entry point for AppNavigationController to go to the game over view
    func goToGameOverView(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        if immediate {
            goToView(.gameOver) {
                complete()
            }
        } else {
            goToViewWithAnimation(.gameOver) {
                complete()
            }
        }
    }
    
    /// Entry point for AppNavigationController to go to the game view
    func goToGameView(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        if immediate {
            goToView(.singleWordGame) {
                complete()
            }
        } else {
            goToViewWithAnimation(.singleWordGame, delay: 0.5) {
                complete()
            }
        }
    }
    
    override func goToViewWithAnimation(_ view: SystemView,
                                        delay: Double = 1.5,
                                        animationLength: Double = 0.5,
                                        pauseLength: Double = 0.0,
                                        onCompletion: @escaping () -> Void = {}) {
        super.goToViewWithAnimation(view, delay: delay, animationLength: animationLength, pauseLength: pauseLength, onCompletion: onCompletion)
    }
}
