import Foundation
import SwiftUI

struct ScreenSize {
    static let width = UIScreen.current?.bounds.width
    static let height = UIScreen.current?.bounds.height
}

struct UISize {
    struct stats {
        static let itemMaxWidth = CGFloat(500)
        static let sectionBottomPadding = CGFloat(30)
        static let sectionSidePadding = ScreenSize.width! * 0.05
    }
    struct keyboard {
        static let maxWidth = CGFloat(500)
        static let maxHeight = CGFloat(180)
    }
    struct main {
        static let maxWidth = CGFloat(600)
        static let sectionSidePadding = ScreenSize.width! * 0.05
    }
    struct gameover {
        static let maxWidth = CGFloat(600)
        static let sectionSidePadding = ScreenSize.width! * 0.05
    }
}

private extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

private extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
