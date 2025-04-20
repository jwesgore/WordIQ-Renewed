import SwiftUI

/// Component of a game toggle
struct SettingsView_Toggle : View {
    
    @Binding var isActive: Bool
    
    var label: String
    var labelSize: RobotoSlabOptions.Size = .title2
    var labelWeight: RobotoSlabOptions.Weight = .semiBold
    
    var body: some View {
        HStack (spacing: 8.0) {
            Text(label)
                .robotoSlabFont(labelSize, labelWeight)
            
            Spacer()
            
            TopDownButton_Toggle(firstButtonSelected: $isActive)
        }
    }
}

extension SettingsView_Toggle {
    init(_ label: String, labelSize: RobotoSlabOptions.Size = .title2, labelWeight: RobotoSlabOptions.Weight = .semiBold, isActive: Binding<Bool>) {
        self.label = label
        self._isActive = isActive
        self.labelSize = labelSize
        self.labelWeight = labelWeight
    }
}
