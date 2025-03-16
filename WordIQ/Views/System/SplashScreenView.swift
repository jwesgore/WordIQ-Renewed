import SwiftUI

/// View that appears when app is opened
struct SplashScreenView: View {

    var body: some View {
        VStack {
            Text(SystemNames.Title.title)
                .font(.custom(RobotoSlabOptions.Weight.bold, fixedSize: CGFloat(RobotoSlabOptions.Size.title)))
            Text(SystemNames.Title.caption)
                .font(.custom(RobotoSlabOptions.Weight.bold, fixedSize: CGFloat(RobotoSlabOptions.Size.caption)))
                .opacity(0.7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    SplashScreenView()
}
