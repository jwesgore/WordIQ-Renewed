import SwiftUI

/// Navigation Controller for single game view
class MultiWordGameNavigationController : NavigationControllerBase {
    
    private static var privateShared: MultiWordGameNavigationController?
    
    class func shared() -> MultiWordGameNavigationController {
        guard let unwrappedShared = privateShared else {
            privateShared = MultiWordGameNavigationController()
            return privateShared!
        }
        return unwrappedShared
    }
    
    class func destroy() {
        privateShared = nil
    }
    
    let multiWordGameViewModel: FourWordGameViewModel
    let multiWordGameOverViewModel = FourWordGameOverViewModel()
    
    private init() {
        self.multiWordGameViewModel = AppNavigationController.shared.multiWordGameModeOptions.getFourWordGameViewModel()
        super.init(.fourWordGame)
    }
    
    func goToGameOverView(immediate: Bool = false) {
        if immediate {
            goToView(.gameOver)
        } else {
            goToViewWithAnimation(.gameOver)
        }
    }
    
    func goToGameView(immediate: Bool = false) {
        if immediate {
            goToView(.singleWordGame)
        } else {
            goToViewWithAnimation(.singleWordGame, delay: 0.5) {
                self.multiWordGameViewModel.playAgain()
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
