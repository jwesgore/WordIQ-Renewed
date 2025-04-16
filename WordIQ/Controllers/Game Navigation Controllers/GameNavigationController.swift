import SwiftUI

/// Navigation Controller for single game view
class GameNavigationController<TGameOptionsModel> :
    NavigationControllerBase<GameViewEnum>, GameNavigationControllerProtocol
    where TGameOptionsModel: GameOptionsBase {
    
    var gameOptions: TGameOptionsModel
    
    init(_ gameOptionsModel: TGameOptionsModel) {
        self.gameOptions = gameOptionsModel
        super.init(.game)
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
            goToView(.gameOver)
        } else {
            goToViewWithAnimation(.gameOver)
        }
    }
    
    /// Entry point for AppNavigationController to go to the game view
    func goToGameView(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        if immediate {
            goToView(.game) {
                complete()
            }
        } else {
            goToViewWithAnimation(.game, delay: 0.5) {
                complete()
            }
        }
    }
    
    override func goToViewWithAnimation(_ view: GameViewEnum,
                                        delay: Double = 1.5,
                                        animationLength: Double = 0.5,
                                        pauseLength: Double = 0.0,
                                        onCompletion: @escaping () -> Void = {}) {
        super.goToViewWithAnimation(view, delay: delay, animationLength: animationLength, pauseLength: pauseLength, onCompletion: onCompletion)
    }
}
