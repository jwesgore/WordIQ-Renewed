import Foundation
import SwiftUI

class Transitions: ObservableObject {
    
    @Published var activeView: SystemView
    
    init(_ activeView: SystemView) {
        self.activeView = activeView
    }
    
    func fadeToWhiteDelay(targetView: SystemView, delay: Double, animationLength: Double = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.fadeToWhite(targetView: targetView)
        }
    }
    
    /// Fades the current activeView out and replaces it with a targetView having an empty view as a buffer in between
    func fadeToWhite(targetView: SystemView, animationLength: Double = 0.5) {
        
        withAnimation(.linear(duration: animationLength)) {
            activeView = .empty
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationLength, execute: {
            withAnimation(.linear(duration: animationLength)) {
                self.activeView = targetView
            }
        })
    }
}
