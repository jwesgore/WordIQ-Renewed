import SwiftUI
import CoreData

class GameDatabaseHelper {

    let context: NSManagedObjectContext
    
    // MARK: Properties
    var allGameResults : [GameResultsModel] = []
    
    var gameCount : Int {
        return allGameResults.count
    }
    
    var totalGuessesAll : (Int, Int, Int) {
        return allGameResults.reduce((0, 0, 0)) { partialResult, gameResult in
            (
                // Total guesses
                partialResult.0 + Int(gameResult.numValidGuesses) + Int(gameResult.numInvalidGuesses),
                // Total valid guesses
                partialResult.1 + Int(gameResult.numValidGuesses),
                // Total invalid guesses
                partialResult.2 + Int(gameResult.numInvalidGuesses)
            )
        }
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
    init(context: NSManagedObjectContext = GameDatabasePersistenceController.shared.container.viewContext) {
        self.context = context
        self.allGameResults = resfreshDataInternal()
    }
    
    // MARK: Public Database Functions
    // Delete all data from database
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GameResultsModel.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            // Execute the batch delete request
            try context.execute(batchDeleteRequest)
            // Clear the local snapshot after deletion
            allGameResults = []
            print("All data deleted successfully.")
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }
    
    /// Refreshes allGameResults snapshot
    func refreshData()  {
        self.allGameResults = self.resfreshDataInternal()
    }
    
    /// Refreshes allGameResults snapshot
    func resfreshDataInternal() -> [GameResultsModel] {
        let fetchRequest: NSFetchRequest<GameResultsModel> = GameResultsModel.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching game results: \(error)")
            return []
        }
    }
    
    // Update database
    func saveGame(_ gameOverData : GameOverDataModel) {
        let newGameResult = GameResultsModel(context: context)
        
        newGameResult.id = UUID()
        newGameResult.date = gameOverData.date
        
        newGameResult.gameDifficulty = Int64(gameOverData.gameDifficulty.id)
        newGameResult.gameMode = Int64(gameOverData.gameMode.id)
        newGameResult.gameResult = Int64(gameOverData.gameResult.id)
        
        newGameResult.numCorrectWords = Int64(gameOverData.numCorrectWords)
        newGameResult.numValidGuesses = Int64(gameOverData.numValidGuesses)
        newGameResult.numInvalidGuesses = Int64(gameOverData.numInvalidGuesses)
        
        newGameResult.targetWord = gameOverData.targetWord.word
        newGameResult.timeElapsed = Int64(gameOverData.timeElapsed)
        newGameResult.timeLimit = Int64(gameOverData.timeLimit ?? 0)
        
        saveContext()
    }
    
    // MARK: Data Calculation Methods
    /// Checks if daily entry already exists
    func doesDailyEntryExist(word: GameWordModel) -> Bool {
        let fetchRequest: NSFetchRequest<GameResultsModel> = GameResultsModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameMode == %d AND targetWord == %@", GameMode.daily.id, word.word)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error fetching daily entry: \(error)")
            return false
        }
    }
    
    /// Get the average amount of time spent playing a game
    func getGameModeAvgTimePerGame(mode : GameMode) -> Int {
        let timePlayed = getGameModeTimePlayed(mode: mode)
        let gamesPlayed = getGameModeCount(mode: mode)
        
        guard gamesPlayed > 0 else { return 0 }
        
        return Int( timePlayed / gamesPlayed )
    }
    
    /// Get the average amount of time spent on each word
    func getGameModeAvgTimePerWord(mode: GameMode) -> Int {
        let gameResults = getGamesByMode(mode)
        let totalScore = gameResults.reduce(0) { $0 + $1.numCorrectWords }
        let totalTimePlayed = gameResults.reduce(0) { $0 + $1.timeElapsed }
        
        guard totalScore > 0 else { return 0 }
        
        return Int(totalTimePlayed) / Int(totalScore)
    }
    
    /// Get the average number of valid guesses per game
    func getGameModeAvgNumGuessesPerGame(mode: GameMode) -> Int {
        let gameResults = getGamesByMode(mode)
        let totalGuesses = gameResults.reduce(0) { $0 + $1.numValidGuesses }
        let totalGamesPlayed = gameResults.count
        
        guard totalGamesPlayed > 0 else { return 0 }
        
        return Int(totalGuesses) / Int(totalGamesPlayed)
    }
    
    /// Get the score for a single game mode
    func getGameModeAvgScore(mode: GameMode) -> Double {
        let gameResults = getGamesByMode(mode)
        
        guard gameResults.count > 0 else { return 0 }
        
        let top = gameResults.reduce(0) { $0 + Int($1.numCorrectWords) }
        let bottom = Double(gameResults.count)
        
        return Double(top) / bottom
    }
   
    /// Get the total amount of games played in a single game mode
    func getGameModeCount(mode : GameMode) -> Int {
        return getGamesByMode(mode).count
    }
    
    /// Get the distribution of games and games played
    func getGameModeDistribution() -> [GameMode : Int] {
        var data : [GameMode : Int] = [:]
        
        data[GameMode.standardgame] = getGameModeCount(mode: .standardgame)
        data[GameMode.rushgame] = getGameModeCount(mode: .rushgame)
        data[GameMode.frenzygame] = getGameModeCount(mode: .frenzygame)
        data[GameMode.zengame] = getGameModeCount(mode: .zengame)
        data[GameMode.daily] = getGameModeCount(mode: .daily)

        return data
    }
    
    /// Get the number of guesses made for a game mode
    func getGameModeNumGuesses(mode : GameMode) -> Int {
        return getGamesByMode(mode).reduce(0){ $0 + Int($1.numValidGuesses + $1.numInvalidGuesses)}
    }
    
    /// Get the time played in a single game mode
    func getGameModeTimePlayed(mode : GameMode) -> Int {
        return getGamesByMode(mode).reduce(0){ $0 + Int($1.timeElapsed)}
    }
    
    /// Get the win percentage of a single game mode
    func getGameModeWinPercentage(mode : GameMode) -> Double {
        let gameResults = getGamesByMode(mode)
        let totalGames = Double(gameResults.count)
        let totalWins = Double(gameResults.filter({ $0.gameResult == GameResult.win.id }).count)
        
        guard totalGames > 0 else { return 0.0 }
        
        return totalWins / totalGames
    }
    
    /// Try and get game over model by id
    func getGameResultsById(id: UUID) -> GameOverDataModel? {
        let fetchRequest: NSFetchRequest<GameResultsModel> = GameResultsModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let gameResults = results.first {
                return GameOverDataModel(gameResults)
            }
        } catch {
            print("Error fetching game results by ID: \(error)")
        }
        return nil
    }
    
    // MARK: Private Functions
    private func getGamesByMode(_ mode: GameMode) -> [GameResultsModel] {
        return allGameResults.filter({ $0.gameMode == mode.id })
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                allGameResults = resfreshDataInternal()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
