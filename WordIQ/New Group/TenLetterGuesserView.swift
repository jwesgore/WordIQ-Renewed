import SwiftUI

struct TenLetterGuesserView : View {
    
    @ObservedObject var viewModel : TenLetterGuesserViewModel
    
    var body : some View  {
        VStack (spacing: 0) {
            
            // GameHeaderView(gameViewModel.gameOptions.gameMode.asStringShort, exitGame: gameViewModel.exitGame, pauseGame: gameViewModel.pauseGame)
            
            Spacer()
            
            HStack {
                Spacer()
                ClockView(clockVM: viewModel.clock)
                    .font(.custom(RobotoSlabOptions.Weight.regular, fixedSize: CGFloat(RobotoSlabOptions.Size.title2)))
            }
            
            TenLetterGuesserBoardView(gameBoardWords: viewModel.gameBoardWords)
            
            Spacer()
            
            // KeyboardView(viewModel: viewModel.keyboardViewModel)
        }
        .padding()
        .transition(.blurReplace)

    }
}

struct TenLetterGuesserBoardView : View {
    
    var gameBoardWords : [TenLetterGuesserWordViewModel]
    
    var body: some View {
        
        VStack (spacing: 1) {
            TenLetterGuesserWordView(viewModel: gameBoardWords[0])
            TenLetterGuesserWordView(viewModel: gameBoardWords[1])
            TenLetterGuesserWordView(viewModel: gameBoardWords[2])
            TenLetterGuesserWordView(viewModel: gameBoardWords[3])
            TenLetterGuesserWordView(viewModel: gameBoardWords[4])
            TenLetterGuesserWordView(viewModel: gameBoardWords[5])
            TenLetterGuesserWordView(viewModel: gameBoardWords[6])
            TenLetterGuesserWordView(viewModel: gameBoardWords[7])
            TenLetterGuesserWordView(viewModel: gameBoardWords[8])
            TenLetterGuesserWordView(viewModel: gameBoardWords[9])
        }
    }
}

struct TenLetterGuesserWordView : View {
    
    @ObservedObject var viewModel : TenLetterGuesserWordViewModel
    
    var body: some View {
        HStack (spacing: 1) {
            GameLetterView(viewModel.letters[0])
            GameLetterView(viewModel.letters[1])
            GameLetterView(viewModel.letters[2])
            GameLetterView(viewModel.letters[3])
            GameLetterView(viewModel.letters[4])
            GameLetterView(viewModel.letters[5])
            GameLetterView(viewModel.letters[6])
            GameLetterView(viewModel.letters[7])
            GameLetterView(viewModel.letters[8])
            GameLetterView(viewModel.letters[9])
        }
    }
}

#Preview {
    TenLetterGuesserView(viewModel: TenLetterGuesserViewModel())
}
