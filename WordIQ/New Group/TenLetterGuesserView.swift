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
                    .robotoSlabFont(.title2, .regular)
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
            GameBoardLetterView(viewModel.letters[0])
            GameBoardLetterView(viewModel.letters[1])
            GameBoardLetterView(viewModel.letters[2])
            GameBoardLetterView(viewModel.letters[3])
            GameBoardLetterView(viewModel.letters[4])
            GameBoardLetterView(viewModel.letters[5])
            GameBoardLetterView(viewModel.letters[6])
            GameBoardLetterView(viewModel.letters[7])
            GameBoardLetterView(viewModel.letters[8])
            GameBoardLetterView(viewModel.letters[9])
        }
    }
}

#Preview {
    TenLetterGuesserView(viewModel: TenLetterGuesserViewModel())
}
