import SwiftUI

/// Navigation Controller for single game view
class SingleWordGameNavigationController : NavigationControllerBase {
    
    static var shared = SingleWordGameNavigationController()
    
    private init() {
        super.init(.singleWordGame)
    }
    
    func dispose() {
        SingleWordGameNavigationController.shared = SingleWordGameNavigationController()
    }
    
    override func goToViewWithAnimation(_ view: SystemView,
                                        delay: Double = 1.5,
                                        animationLength: Double = 0.5,
                                        pauseLength: Double = 0.0,
                                        onCompletion: @escaping () -> Void = {}) {
        super.goToViewWithAnimation(view, delay: delay, animationLength: animationLength, pauseLength: pauseLength, onCompletion: onCompletion)
    }
}
