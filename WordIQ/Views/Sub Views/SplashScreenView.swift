import SwiftUI

/// View that appears when app is opened
struct SplashScreenView: View {
    @ObservedObject var transitions: BaseViewNavigation
    
    init() {
        self.transitions = BaseViewNavigation()
    }
    
    var body: some View {
        
        ZStack {
            switch self.transitions.activeView {
            case .root:
                VStack {
                    Text(SystemNames.Title.title)
                        .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title)))
                    Text(SystemNames.Title.caption)
                        .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.caption)))
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.appBackground)
                .transition(.blurReplace)
            case .target:
                GameModeSelectionView()
            case .blank:
                Color.appBackground
                    .transition(.blurReplace)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .onAppear {
            transitions.fadeToBlankDelay(delay: 2.5, animationLength: 0.5, hang: 0.5)
        } 
    }
}

#Preview {
    SplashScreenView()
}
