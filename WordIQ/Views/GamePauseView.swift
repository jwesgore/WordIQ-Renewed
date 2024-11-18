import SwiftUI

struct GamePauseView : View {
    
    @ObservedObject var gameViewModel : GameViewModel
    
    init (_ gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.gameViewModel.resumeGame()
            }, label: {
                Text("Test")
            })
        }
    }
}
