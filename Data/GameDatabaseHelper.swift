import SwiftUI
import CoreData

class GameDatabaseHelper {

    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: Public Functions
    func saveGame(gameOverData : GameOverModel) {
        let newGameResult = GameResultsModel(context: context)
        
        newGameResult.id = UUID()
        newGameResult.date = gameOverData.date
        
        newGameResult.gameDifficulty = Int64(gameOverData.gameDifficulty.asInt)
        newGameResult.gameMode = Int64(gameOverData.gameMode.id)
        newGameResult.gameResult = Int64(gameOverData.gameResult.asInt)
        
        newGameResult.numCorrectWords = Int64(gameOverData.numCorrectWords)
        newGameResult.numValidGuesses = Int64(gameOverData.numValidGuesses)
        newGameResult.numInvalidGuesses = Int64(gameOverData.numInvalidGuesses)
        
        newGameResult.targetWord = gameOverData.targetWord.word
        newGameResult.timeElapsed = Int64(gameOverData.timeElapsed)
        newGameResult.timeLimit = Int64(gameOverData.timeLimit ?? 0)
        
        saveContext()
    }
    
    func getGameCount() -> Int {
        let fetchRequest: NSFetchRequest<GameResultsModel> = GameResultsModel.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Error fetching game results: \(error)")
            return 0
        }
    }
    
    // MARK: Private Functions
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
