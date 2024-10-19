import Foundation
import SwiftUI

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func modifier (_ x: CGFloat) -> CGFloat {
        return 10 * sin(x * .pi * 2)
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let transform = ProjectionTransform(CGAffineTransform(translationX: modifier(animatableData), y: 0))
        return transform
    }
}
