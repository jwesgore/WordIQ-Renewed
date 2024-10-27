import SwiftUI

/// View that appears when app is opened
struct SplashScreenView: View {
    @ObservedObject var transitions: Transitions
    @State private var isActive : Bool
    
    init() {
        self.transitions = Transitions(.splashScreen)
        self.isActive = false
    }
    
    var body: some View {
        ZStack {
            switch self.transitions.activeView {
            case .splashScreen:
                VStack {
                    Text(SystemNames.Title.title)
                        .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.title)))
                    Text(SystemNames.Title.caption)
                        .font(.custom(RobotoSlabOptions.Weight.bold, size: CGFloat(RobotoSlabOptions.Size.caption)))
                        .opacity(0.7)
                }
            case .gameModeSelection:
                GameModeSelectionView(gameModelSelectionVM: GameModeSelectionViewModel())
            default:
                EmptyView()
            }
        }
        .onAppear {
            transitions.fadeToWhiteDelay(targetView: .gameModeSelection, delay: 2.5)
        }
    }
}

#Preview {
    SplashScreenView()
}
