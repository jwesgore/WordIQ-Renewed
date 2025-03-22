import SwiftUI

/// Removes animation from button
struct NoAnimation: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

extension Button {
    func removeDefaultButtonStyle() -> some View {
        self.buttonStyle(NoAnimation())
    }
}
