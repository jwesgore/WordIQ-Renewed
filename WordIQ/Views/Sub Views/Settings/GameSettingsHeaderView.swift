import SwiftUI

/// Struct for game settings header view
struct GameSettingsHeaderView : View {
    
    let headerText: String
    
    var body: some View {
        Text(headerText)
            .font(.custom(RobotoSlabOptions.Weight.semiBold, size: CGFloat(RobotoSlabOptions.Size.title2)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 8)
    }
}

extension GameSettingsHeaderView {
    init (_ headerText: String) {
        self.headerText = headerText
    }
}
