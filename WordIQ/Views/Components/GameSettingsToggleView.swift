import SwiftUI

/// Component of a game toggle
struct GameSettingsToggle : View {
    
    var label: String
    @Binding var isActive: Bool
    
    var body: some View {
        Toggle(label, isOn: $isActive)
            .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title3)))
            .tint(.gray)
    }
}

extension GameSettingsToggle {
    init(_ label: String, isActive: Binding<Bool>) {
        self.label = label
        self._isActive = isActive
    }
}
