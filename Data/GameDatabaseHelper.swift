import SwiftUI
import CoreData

/// Database Helper for retrieve saved games
class GameDatabaseHelper {
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    private(set) var allGameResults: [CDGameResultsModel] = []

    var gameCount: Int {
        allGameResults.count
    }
    
    var totalGuessesAll: (total: Int, valid: Int, invalid: Int) {
        allGameResults.reduce((0, 0, 0)) { partialResult, gameResult in
            (
                partialResult.total + Int(gameResult.numberOfValidGuesses) + Int(gameResult.numberOfInvalidGuesses),
                partialResult.valid + Int(gameResult.numberOfValidGuesses),
                partialResult.invalid + Int(gameResult.numberOfInvalidGuesses)
            )
        }
    }

    var totalTimePlayed: Int {
        allGameResults.reduce(0) { $0 + Int($1.timeElapsed) }
    }
    
    var lastDailyPlayed: Int {
        calculateMaxValue(for: CDDailyModeGameResult.self, keyPath: "dailyId", maxKey: "maxDailyId") ?? 0
    }

    // MARK: - Constructor
    init(context: NSManagedObjectContext = GameDatabasePersistenceController.shared.container.viewContext) {
        self.context = context
        refreshData()
    }

    // MARK: - Refresh Functions
    private func refreshData() {
        allGameResults = fetchResults(for: CDGameResultsModel.self)
    }

    private func fetchResults<T: NSManagedObject>(for modelType: T.Type) -> [T] {
        let fetchRequest = T.fetchRequest() as! NSFetchRequest<T>
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching \(modelType): \(error)")
            return []
        }
    }

    // MARK: - Database Utility Functions
    func deleteAllData() {
        guard let persistentStoreCoordinator = context.persistentStoreCoordinator else {
            print("Persistent Store Coordinator not found.")
            return
        }
        
        for entity in persistentStoreCoordinator.managedObjectModel.entities {
            guard let entityName = entity.name else { continue }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
                print("Cleared data for entity: \(entityName).")
            } catch {
                print("Failed to delete entity \(entityName): \(error)")
            }
        }
        context.reset()
    }

    // MARK: - Calculation Functions
    func getGameStatistics<T: CDGameResultsModel>(for modelType: T.Type) -> StatsModel {
        var model = StatsModel()
        
        let results = fetchResults(for: modelType)
        let totalGames = results.count
        let totalTimePlayed = Int(results.reduce(0) { $0 + $1.timeElapsed })
        let totalScore = Int(results.reduce(0) { $0 + $1.numberOfCorrectWords })
        let totalInvalidGuesses = Int(results.reduce(0) { $0 + $1.numberOfInvalidGuesses })
        let totalValidGuesses = Int(results.reduce(0) { $0 + $1.numberOfValidGuesses })
        
        model.totalGamesPlayed = totalGames
        model.totalCorrectWords = totalScore
        model.totalTimePlayed = totalTimePlayed
        model.totalValidGuesses = totalValidGuesses
        model.totalInvalidGuesses = totalInvalidGuesses
        
        if modelType is CDWinnableGame {
            let totalWins = results.compactMap { gameResult in
                guard let winnableGame = gameResult as? CDWinnableGame else { return false }
                return winnableGame.result == GameResult.win.id
            }.count
            
            model.totalWins = totalWins
        }
    
        return model
    }
    
    func getGameModeWinPercentage<T: CDGameResultsModel & CDWinnableGame>(for modelType: T.Type) -> Double {
        let results = fetchResults(for: modelType)
        let totalGames = Double(results.count)
        let totalWins = Double(results.filter { $0.result == GameResult.win.id }.count)
        
        return totalGames > 0 ? totalWins / totalGames : 0.0
    }

    func getGameModeDistribution() -> [GameMode: Int] {
        [
            .standardMode: fetchResults(for: CDStandardModeGameResult.self).count,
            .rushMode: fetchResults(for: CDRushModeGameResult.self).count,
            .frenzyMode: fetchResults(for: CDFrenzyModeGameResult.self).count,
            .zenMode: fetchResults(for: CDZenModeGameResult.self).count,
            .dailyGame: fetchResults(for: CDDailyModeGameResult.self).count
        ]
    }

    // MARK: - Helper Functions
    private func calculateMaxValue<T: NSManagedObject>(for modelType: T.Type, keyPath: String, maxKey: String) -> Int? {
        let fetchRequest = T.fetchRequest() as! NSFetchRequest<T>
        let keyPathExpression = NSExpression(forKeyPath: keyPath)
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = maxKey
        expressionDescription.expression = maxExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType

        do {
            let result = try context.fetch(fetchRequest).first
            if let maxDailyId = result?["maxDailyId"] as? Int64 {
                return Int(maxDailyId)
            } else {
                return 0
            }
        } catch {
            print("Error calculating max value for \(keyPath): \(error)")
            return nil
        }
    }
    
    // MARK: - Save Functions
    // Update database
    func saveGame(_ gameOverData : GameOverDataModel) {
        switch gameOverData.gameMode {
        case .dailyGame:
            _ = createDailyGameResult(gameOverData)
        case .standardMode:
            _ = createStandardGameResult(gameOverData)
        case .rushMode:
            _ = createRushGameResult(gameOverData)
        case .frenzyMode:
            _ = createFrenzyGameResult(gameOverData)
        case .zenMode:
            _ = createZenGameResult(gameOverData)
        case .quadWordMode:
            _ = createQuadStandardGameResult(gameOverData)
        default:
            fatalError("Invalid game over data model")
        }
        
        saveContext()
    }
    
    /// Save the current context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    /// Creates a valid CDDailyModeGameResult from the game over data
    private func createDailyGameResult(_ gameOverData : GameOverDataModel) -> CDDailyModeGameResult {
        let gameResult = CDDailyModeGameResult(context: context)
        
        gameResult.date = gameOverData.date
        gameResult.dailyId = Int64(gameOverData.currentTargetWord?.daily ?? 0)
        gameResult.gameMode = Int64(gameOverData.gameMode.id)
        gameResult.id = UUID()
        gameResult.numberOfCorrectWords = Int64(gameOverData.targetWordsCorrect.count)
        gameResult.numberOfInvalidGuesses = Int64(gameOverData.numberOfInvalidGuesses)
        gameResult.numberOfValidGuesses = Int64(gameOverData.numberOfValidGuesses)
        gameResult.result = Int64(gameOverData.gameResult.id)
        gameResult.timeElapsed = Int64(gameOverData.timeElapsed)
        
        return gameResult
    }
    
    /// Creates a valid CDStandardModeGameResult from the game over data
    private func createStandardGameResult(_ gameOverData : GameOverDataModel) -> CDStandardModeGameResult {
        let gameResult = CDStandardModeGameResult(context: context)

        gameResult.date = gameOverData.date
        gameResult.difficulty = Int64(gameOverData.difficulty.id)
        gameResult.gameMode = Int64(gameOverData.gameMode.id)
        gameResult.id = UUID()
        gameResult.numberOfCorrectWords = Int64(gameOverData.targetWordsCorrect.count)
        gameResult.numberOfInvalidGuesses = Int64(gameOverData.numberOfInvalidGuesses)
        gameResult.numberOfValidGuesses = Int64(gameOverData.numberOfValidGuesses)
        gameResult.result = Int64(gameOverData.gameResult.id)
        gameResult.timeElapsed = Int64(gameOverData.timeElapsed)
        
        return gameResult
    }
    
    /// Creates a valid CDStandardModeGameResult from the game over data
    private func createRushGameResult(_ gameOverData : GameOverDataModel) -> CDRushModeGameResult {
        let gameResult = CDRushModeGameResult(context: context)

        gameResult.date = gameOverData.date
        gameResult.difficulty = Int64(gameOverData.difficulty.id)
        gameResult.gameMode = Int64(gameOverData.gameMode.id)
        gameResult.id = UUID()
        gameResult.numberOfCorrectWords = Int64(gameOverData.targetWordsCorrect.count)
        gameResult.numberOfInvalidGuesses = Int64(gameOverData.numberOfInvalidGuesses)
        gameResult.numberOfValidGuesses = Int64(gameOverData.numberOfValidGuesses)
        gameResult.result = Int64(gameOverData.gameResult.id)
        gameResult.timeElapsed = Int64(gameOverData.timeElapsed)
        gameResult.timeLimit = Int64(gameOverData.timeLimit)
        
        return gameResult
    }
    
    /// Creates a valid CDStandardModeGameResult from the game over data
    private func createFrenzyGameResult(_ gameOverData : GameOverDataModel) -> CDFrenzyModeGameResult {
        let gameResult = CDFrenzyModeGameResult(context: context)

        gameResult.date = gameOverData.date
        gameResult.difficulty = Int64(gameOverData.difficulty.id)
        gameResult.gameMode = Int64(gameOverData.gameMode.id)
        gameResult.id = UUID()
        gameResult.numberOfCorrectWords = Int64(gameOverData.targetWordsCorrect.count)
        gameResult.numberOfInvalidGuesses = Int64(gameOverData.numberOfInvalidGuesses)
        gameResult.numberOfValidGuesses = Int64(gameOverData.numberOfValidGuesses)
        gameResult.timeElapsed = Int64(gameOverData.timeElapsed)
        gameResult.timeLimit = Int64(gameOverData.timeLimit)
        
        return gameResult
    }
    
    /// Creates a valid CDStandardModeGameResult from the game over data
    private func createZenGameResult(_ gameOverData : GameOverDataModel) -> CDZenModeGameResult {
        let gameResult = CDZenModeGameResult(context: context)

        gameResult.date = gameOverData.date
        gameResult.difficulty = Int64(gameOverData.difficulty.id)
        gameResult.gameMode = Int64(gameOverData.gameMode.id)
        gameResult.id = UUID()
        gameResult.numberOfCorrectWords = Int64(gameOverData.targetWordsCorrect.count)
        gameResult.numberOfInvalidGuesses = Int64(gameOverData.numberOfInvalidGuesses)
        gameResult.numberOfValidGuesses = Int64(gameOverData.numberOfValidGuesses)
        gameResult.timeElapsed = Int64(gameOverData.timeElapsed)
        
        return gameResult
    }
    
    /// Creates a valid CDStandardModeGameResult from the game over data
    private func createQuadStandardGameResult(_ gameOverData : GameOverDataModel) -> CDQuadStandardGameResult {
        let gameResult = CDQuadStandardGameResult(context: context)

        gameResult.date = gameOverData.date
        gameResult.gameMode = Int64(gameOverData.gameMode.id)
        gameResult.id = UUID()
        gameResult.numberOfCorrectWords = Int64(gameOverData.targetWordsCorrect.count)
        gameResult.numberOfInvalidGuesses = Int64(gameOverData.numberOfInvalidGuesses)
        gameResult.numberOfValidGuesses = Int64(gameOverData.numberOfValidGuesses)
        gameResult.result = Int64(gameOverData.gameResult.id)
        gameResult.timeElapsed = Int64(gameOverData.timeElapsed)
        
        return gameResult
    }
}
