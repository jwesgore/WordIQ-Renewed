import SwiftUI

struct NotificationPermissionView : View {
    
    
    var body: some View {
        VStack {
            Text(SystemNames.Title.title)
                .robotoSlabFont(.title, .bold)
            Text(SystemNames.Title.caption)
                .robotoSlabFont(.caption, .bold)
                .opacity(0.7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
}
