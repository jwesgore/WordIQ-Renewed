import UIKit

/// Class to help simplify applying haptics
class HapticsHelper {
    static let shared = HapticsHelper()
    
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator()
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    private init() {
        // Prepare the generators to minimize delay
        impactFeedbackGenerator.prepare()
        notificationFeedbackGenerator.prepare()
    }

    func impact(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        if (UserDefaultsClient.shared.setting_hapticFeedback) {
            impactFeedbackGenerator.impactOccurred(intensity: feedbackStyle.intensity)
        }
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        if (UserDefaultsClient.shared.setting_hapticFeedback) {
            notificationFeedbackGenerator.notificationOccurred(feedbackType)
        }
    }
}

/// Extension to map feedback style to intensity
private extension UIImpactFeedbackGenerator.FeedbackStyle {
    var intensity: CGFloat {
        switch self {
        case .light:
            return 0.4
        case .medium:
            return 0.7
        case .heavy:
            return 1.0
        case .soft:
            return 0.5
        case .rigid:
            return 1.0
        @unknown default:
            return 1.0
        }
    }
}
