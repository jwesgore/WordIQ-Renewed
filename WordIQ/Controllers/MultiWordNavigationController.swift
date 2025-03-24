import SwiftUI

/// Navigation Controller for single game view
class MultiWordGameNavigationController : NavigationControllerBase {
    
    static var shared = MultiWordGameNavigationController()
    
    private init() {
        super.init(.fourWordGame)
    }
    
    func dispose() {
        MultiWordGameNavigationController.shared = MultiWordGameNavigationController()
    }
    
    override func goToViewWithAnimation(_ view: SystemView,
                                        delay: Double = 1.5,
                                        animationLength: Double = 0.5,
                                        pauseLength: Double = 0.0,
                                        onCompletion: @escaping () -> Void = {}) {
        super.goToViewWithAnimation(view, delay: delay, animationLength: animationLength, pauseLength: pauseLength, onCompletion: onCompletion)
    }
}
