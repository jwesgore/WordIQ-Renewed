import Foundation
import SwiftUI

class Transitions: ObservableObject {
    
    @Published var activeView: ActiveView
    
    init(_ activeView: ActiveView) {
        self.activeView = activeView
    }
    
    func fadeToWhiteDelay(targetView: ActiveView, delay: Double, animationLength: Double = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.fadeToWhite(targetView: targetView)
        }
    }
    
    /// Fades the current activeView out and replaces it with a targetView having an empty view as a buffer in between
    func fadeToWhite(targetView: ActiveView, animationLength: Double = 0.5) {
        
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
