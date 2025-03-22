import SwiftUI

/// Component of a game toggle
struct GameSettingsToggle : View {
    
    var label: String
    @Binding var isActive: Bool
    
    var body: some View {
        Toggle(label, isOn: $isActive)
            .robotoSlabFont(.title3, .regular)
            .tint(.gray)
    }
}

extension GameSettingsToggle {
    init(_ label: String, isActive: Binding<Bool>) {
        self.label = label
        self._isActive = isActive
    }
}
