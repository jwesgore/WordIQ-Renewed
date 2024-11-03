import Foundation
import SwiftUI

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func modifier (_ x: CGFloat) -> CGFloat {
        return 5 * sin(x * .pi * 2)
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: modifier(animatableData), y: 0))
    }
}
