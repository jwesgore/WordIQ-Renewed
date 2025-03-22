import SwiftUI

class GameSelectionNavigationController : NavigationControllerBase {
    static let shared = GameSelectionNavigationController()

    
    init() {
        super.init(.gameModeSelection)
    }
    
    /// Transition to a view with animation fading to a blank view
    override func goToViewWithAnimation(_ view: SystemView,
                                        delay: Double = 0.0,
                                        animationLength: Double = 0.2,
                                        pauseLength: Double = 0.0,
                                        onCompletion: @escaping () -> Void = {}) {
        super.goToViewWithAnimation(view, delay: delay, animationLength: animationLength, pauseLength: pauseLength, onCompletion: onCompletion)
    }
}
