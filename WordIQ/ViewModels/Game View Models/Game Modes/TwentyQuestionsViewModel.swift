//
///// View Model to support twenty questions mode
//class TwentyQuestionsViewModel : SingleWordGameViewModel {
//    
//    private let maxTargetWords = 5
//    private let maxGuessesAllowed = 20
//    
//    private var targetWordIndex = 0
//    private var targetWords: [DatabaseWordModel]
//    override var targetWord: DatabaseWordModel {
//        targetWords[targetWordIndex]
//    }
//    
//    override init(gameOptions: SingleWordGameModeOptionsModel) {
//        
//        self.targetWords = WordDatabaseHelper.shared.fetchMultipleRandomFiveLetterWord(withDifficulty: gameOptions.gameDifficulty, count: maxTargetWords)
//        
//        super.init(gameOptions: gameOptions)
//    }
//    
//    override func correctWordSubmitted() {
//        // Call Base Logic
//        super.correctWordSubmitted()
//        
//        if let activeWord = gameBoardViewModel.activeWord, let gameWord = activeWord.getWord() {
//            
//            
//            gameOverDataModel.correctlyGuessedWords?.append(gameWord)
//            gameOverDataModel.lastGuessedWord = gameWord
//            
//            // Check if user has lost the game (from maxing out guess count)
//            
//            
//            // Check if User has beaten the game, if not load the next word
//            targetWordIndex += 1
//            
//            if targetWordIndex >= maxTargetWords {
//                gameOver()
//            } else {
//                
//                gameBoardViewModel.resetBoardWithAnimation(delay: 0.5, hardReset: true) {
//                    self.keyboardViewModel.resetKeyboard()
//                    self.isKeyboardUnlocked = true
//                }
//            }
//        }
//    }
//    
//    override func wrongWordSubmitted() {
//        // Call Base Logic
//        super.wrongWordSubmitted()
//        
//        // If the position has reached the end of the board, reset it
//        super.gameBoardViewModel.goToNextLine {
//            self.gameBoardViewModel.resetBoardWithAnimation(delay: 1.0, loadHints: true)
//        }
//    }
//    
//    /// Checks the number of guesses to see if the user has lost
////    private func checkNumberOfGuesses() -> Bool {
////        if gameOverDataModel.numValidGuesses == maxGuessesAllowed {
////            gameOver()
////            return false
////        }
////    }
//}
