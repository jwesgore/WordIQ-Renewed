import Foundation
import SwiftUI

class BaseViewNavigation: ObservableObject {
    
    @Published private(set) var activeView: BaseViewNavigationEnum
    
    init() {
        self.activeView = .root
    }
    
    func goToTarget() {
        self.activeView = .target
    }
    
    func fadeToBlankDelay(fromRoot:Bool = true, delay: Double, animationLength: Double = 0.5, hang: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.fadeToBlank(fromRoot: fromRoot, animationLength: animationLength, hang: hang)
        }
    }
    
    /// Fades the current activeView out and replaces it with a targetView having an empty view as a buffer in between
    func fadeToBlank(fromRoot:Bool = true, animationLength: Double = 0.5, hang: Double = 0.0) {
        
        withAnimation(.linear(duration: animationLength)) {
            activeView = .blank
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationLength + hang, execute: {
            withAnimation {
                self.activeView = fromRoot ? .target : .root
            }
        })
    }
}


enum BaseViewNavigationEnum {
    case root, target, blank
}
