import SwiftUI
import CoreData

class GameDatabaseHelper {

    let context: NSManagedObjectContext
    
    // MARK: Properties
    var gameCount : Int {
        return getAllGameResults().count
    }
    
    // MARK: Constructor
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
    
    func getAllGameResults() -> [GameResultsModel] {
        let fetchRequest: NSFetchRequest<GameResultsModel> = GameResultsModel.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching game results: \(error)")
            return []
        }
    }
    
    func getGameModeCount(mode : GameMode) -> Int {
        let games = getAllGameResults()
        return games.filter({ $0.gameMode == mode.id }).count
    }
    
    func getWinPercentage(mode : GameMode) -> Double {
        let games = getAllGameResults()
        let totalGames = Double(games.filter({ $0.gameMode == mode.id }).count)
        let totalWins = Double(games.filter({ $0.gameResult == GameResult.win.asInt }).count)
        return totalWins / totalGames
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
