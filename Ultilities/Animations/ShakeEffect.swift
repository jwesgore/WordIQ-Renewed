import Foundation
import SwiftUI

/// Applies a shake effect to a view
struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func modifier (_ x: CGFloat) -> CGFloat {
        return 5 * sin(x * .pi * 2)
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: modifier(animatableData), y: 0))
    }
}
