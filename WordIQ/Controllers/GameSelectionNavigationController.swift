import SwiftUI

class GameSelectionNavigationController : ObservableObject {
    static let shared = GameSelectionNavigationController()
    
    @Published private(set) var activeView : SystemView
    @Published private(set) var previousView : SystemView
    
    init() {
        self.activeView = .gameModeSelection
        self.previousView = .gameModeSelection
    }
    
    /// Transition to a view with animation fading to a blank view
    func goToViewWithAnimation(_ view: SystemView,
                               delay: Double = 0.0,
                               animationLength: Double = 0.2,
                               pauseLength: Double = 0.0) {
        
        self.previousView = self.activeView
        
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
