import SwiftUI

/// Base class for all other navigation controllers
class NavigationControllerBase: ObservableObject {
        
    @Published private(set) var activeView : SystemView
    @Published private(set) var previousView : SystemView
    
    init(_ startView: SystemView = .splashScreen) {
        self.activeView = startView
        self.previousView = startView
    }
    
    /// Transition to a view immediately
    func goToView(_ view: SystemView, complete: @escaping () -> Void = {}) {
        self.previousView = self.activeView
        self.activeView = view
        
        complete()
    }
    
    /// Transition to a view with animation fading to a blank view
    func goToViewWithAnimation(_ view: SystemView,
                               delay: Double = 0.0,
                               animationLength: Double = 0.5,
                               pauseLength: Double = 0.0,
                               onCompletion: @escaping () -> Void = {}) {
        
        guard activeView != view else { return }
        
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
                
                onCompletion()
            }
        }
    }
}
