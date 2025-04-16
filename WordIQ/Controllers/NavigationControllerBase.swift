import SwiftUI

/// Base class for all other navigation controllers
class NavigationControllerBase<TEnum>: ObservableObject
    where TEnum : NavigationEnum {
        
    @Published private(set) var activeView : TEnum
    @Published private(set) var previousView : TEnum
    
    init(_ startView: TEnum) {
        self.activeView = startView
        self.previousView = startView
    }
    
    /// Transition to a view immediately
    func goToView(_ view: TEnum, complete: @escaping () -> Void = {}) {
        self.previousView = self.activeView
        self.activeView = view
        
        complete()
    }
    
    /// Transition to a view with animation fading to a blank view
    func goToViewWithAnimation(_ view: TEnum,
                               delay: Double = 0.0,
                               animationLength: Double = 0.5,
                               pauseLength: Double = 0.0,
                               onCompletion: @escaping () -> Void = {}) {
        
        guard activeView != view else { return }
        
        self.previousView = self.activeView
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // Fade to an empty view
            withAnimation(.linear(duration: animationLength)) {
                self.activeView = TEnum.empty()
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
