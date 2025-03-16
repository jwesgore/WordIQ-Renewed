import SwiftUI

class NavigationController: ObservableObject {
    
    static let shared = NavigationController()
    
    @Published private(set) var activeView : SystemView

    init(_ startView: SystemView = .splashScreen) {
        self.activeView = startView
    }
    
    /// Transition to a view immediately
    func goToView(_ view: SystemView) {
        self.activeView = view
    }
    
    /// Transition to a view with animation fading to a blank view
    func goToViewWithAnimation(_ view: SystemView,
                               delay: Double = 0.0,
                               animationLength: Double = 0.5,
                               pauseLength: Double = 0.0) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            // Fade to an empty view
            withAnimation(.linear(duration: animationLength)) {
                self.activeView = .empty
            }
            
            // Fade back into the target view
            DispatchQueue.main.asyncAfter(deadline: .now() + animationLength + pauseLength) {
                withAnimation {
                    self.activeView = view
                }
            }
        }
    }
    
}
