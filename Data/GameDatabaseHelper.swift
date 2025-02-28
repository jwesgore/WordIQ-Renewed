import SwiftUI
import CoreData

class GameDatabaseHelper {

    let context: NSManagedObjectContext
    
    // MARK: Properties
    var allGameResults : [GameResultsModel] = []
    
    var gameCount : Int {
        return allGameResults.count
    }
    
    var totalGuesses : Int {
        return allGameResults.reduce(0) { $0 + Int($1.numValidGuesses) + Int($1.numInvalidGuesses) }
    }
    
    var totalGuessesValid : Int {
        return allGameResults.reduce(0) { $0 + Int($1.numValidGuesses) }
    }
    
    var totalGuessesInvalid : Int {
        return allGameResults.reduce(0) { $0 + Int($1.numInvalidGuesses) }
    }
    
    var totalTimePlayed : Int {
        return allGameResults.reduce(0) { $0 + Int($1.timeElapsed) }
    }
    
    // MARK: Constructor
    init(context: NSManagedObjectContext) {
        self.context = context
        self.allGameResults = refreshData()
    }
    
    // MARK: Public Functions
    func refreshData() -> [GameResultsModel] {
        let fetchRequest: NSFetchRequest<GameResultsModel> = GameResultsModel.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching game results: \(error)")
            return []
        }
    }
    
    func saveGame(gameOverData : GameOverModel) {
        let newGameResult = GameResultsModel(context: context)
        
        newGameResult.id = UUID()
        newGameResult.date = gameOverData.date
        
        newGameResult.gameDifficulty = Int64(gameOverData.gameDifficulty.id)
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
    
    // Get the total amount of games played in a single game mode
    func getGameModeCount(mode : GameMode) -> Int {
        return allGameResults.filter({ $0.gameMode == mode.id }).count
    }
    
    func getGameModeDistribution() -> [GameMode : Int] {
        var data : [GameMode : Int] = [:]
        
        data[GameMode.standardgame] = getGameModeCount(mode: .standardgame)
        data[GameMode.rushgame] = getGameModeCount(mode: .rushgame)
        data[GameMode.frenzygame] = getGameModeCount(mode: .frenzygame)
        data[GameMode.zengame] = getGameModeCount(mode: .zengame)
        data[GameMode.daily] = getGameModeCount(mode: .daily)

        return data
    }
    
    // Get the time played in a single game mode
    func getGameModeTimePlayed(mode : GameMode) -> Int {
        return allGameResults.reduce(0){ $0 + Int($1.timeElapsed)}
    }
    
    // Get the win percentage of a single game mode
    func getGameModeWinPercentage(mode : GameMode) -> Double {
        let totalGames = Double(allGameResults.count)
        let totalWins = Double(allGameResults.filter({ $0.gameResult == GameResult.win.asInt }).count)
        return totalWins / totalGames
    }
    
    // MARK: Private Functions
    private func getGamesByMode(_ mode: GameMode) -> [GameResultsModel] {
        return allGameResults.filter({ $0.gameMode == mode.id })
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                allGameResults = refreshData()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
