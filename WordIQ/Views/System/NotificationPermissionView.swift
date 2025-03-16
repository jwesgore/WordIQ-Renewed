import SwiftUI

struct NotificationPermissionView : View {
    
    
    var body: some View {
        VStack {
            Text(SystemNames.Title.title)
                .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title)))
            Text(SystemNames.Title.caption)
                .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.caption)))
                .opacity(0.7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
}
