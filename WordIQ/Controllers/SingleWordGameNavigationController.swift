import SwiftUI

/// Navigation Controller for single word game view
class SingleWordGameNavigationController : NavigationControllerBase {

    private static var privateShared: SingleWordGameNavigationController?
    
    class func shared() -> SingleWordGameNavigationController {
        guard let unwrappedShared = privateShared else {
            privateShared = SingleWordGameNavigationController()
            return privateShared!
        }
        return unwrappedShared
    }
    
    class func destroy() {
        privateShared = nil
    }
    
    let singleWordGameViewModel: SingleWordGameViewModel
    let singleWordGameOverViewModel = SingleWordGameOverViewModel()
    
    var singleWordGameModeOptions: SingleWordGameModeOptionsModel {
        return AppNavigationController.shared.singleWordGameModeOptions
    }
    
    init() {
        self.singleWordGameViewModel = AppNavigationController.shared.singleWordGameModeOptions.getSingleWordGameViewModel()
        super.init(.singleWordGame)
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
                self.singleWordGameViewModel.playAgain()
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
