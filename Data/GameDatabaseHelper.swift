import SwiftUI
import SwiftData

/// Database Helper for retrieve saved games
class GameDatabaseHelper {
    
    // MARK: - Properties
    private var context: ModelContext

    var gameCount: Int {
        return fetchAllResults().count
    }

    var totalGuessesAll: (total: Int, valid: Int, invalid: Int) {
        let results = fetchAllResults()
        let total = results.count
        let valid = results.reduce(0) { $0 + $1.numberOfValidGuesses }
        let invalid = results.reduce(0) { $0 + $1.numberOfInvalidGuesses }
        return (total, valid, invalid)
    }

    var totalTimePlayed: Int {
        return fetchAllResults().reduce(0) { $0 + $1.timeElapsed }
    }
    
    var lastDailyPlayed: Int {
        let dailyResults = fetchResults(for: SDDailyGameResult.self)
        return dailyResults.last?.dailyId ?? -1
    }

    // MARK: - Constructor
    // Initialize with ModelContext
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Database Utility Functions
    func deleteAllData() {
        do {
            try context.delete(model: SDStandardGameResult.self)
            try context.delete(model: SDRushGameResult.self)
            try context.delete(model: SDFrenzyGameResult.self)
            try context.delete(model: SDZenGameResult.self)
            try context.delete(model: SDDailyGameResult.self)
            try context.delete(model: SDQuadStandardGameResult.self)
            try context.save()
        } catch {
            fatalError("Failed to delete all data: \(error)")
        }
    }

    // MARK: - Calculation Functions
    func getGameStatistics<TGameResult: SDGameResult & PersistentModel>(for modelType: TGameResult.Type) -> StatsModel {
        var model = StatsModel()
        
        let results = fetchResults(for: modelType)
        let totalGames = results.count
        let totalTimePlayed = results.reduce(0) { $0 + $1.timeElapsed }
        let totalScore = results.reduce(0) { $0 + $1.numberOfCorrectWords }
        let totalInvalidGuesses = results.reduce(0) { $0 + $1.numberOfInvalidGuesses }
        let totalValidGuesses = results.reduce(0) { $0 + $1.numberOfValidGuesses }
        
        model.totalGamesPlayed = totalGames
        model.totalCorrectWords = totalScore
        model.totalTimePlayed = totalTimePlayed
        model.totalValidGuesses = totalValidGuesses
        model.totalInvalidGuesses = totalInvalidGuesses
        
        if modelType is SDWinnable {
            let totalWins = results.compactMap { gameResult in
                guard let winnableGame = gameResult as? CDWinnableGame else { return false }
                return winnableGame.result == GameResult.win.id
            }.count
            
            model.totalWins = totalWins
        }
    
        return model
    }
    
    func getGameModeWinPercentage<TGameResult: SDGameResult & SDWinnable & PersistentModel>(for modelType: TGameResult.Type) -> Double {
        let results = fetchResults(for: modelType)
        let totalGames = Double(results.count)
        let totalWins = Double(results.filter { $0.result == .win }.count)
        
        return totalGames > 0 ? totalWins / totalGames : 0.0
    }

    func getGameModeDistribution() -> [GameMode: Int] {
        [
            .standardMode: fetchResults(for: SDStandardGameResult.self).count,
            .rushMode: fetchResults(for: SDRushGameResult.self).count,
            .frenzyMode: fetchResults(for: SDFrenzyGameResult.self).count,
            .zenMode: fetchResults(for: SDZenGameResult.self).count,
            .dailyGame: fetchResults(for: SDDailyGameResult.self).count
        ]
    }

    // MARK: - Helper Functions
    // Fetch objects from the ModelContext
    func fetchResults<TGameResult: SDGameResult & PersistentModel>(
        for modelType: TGameResult.Type,
        predicate: Predicate<TGameResult>? = nil,
        sortDescriptors: [SortDescriptor<TGameResult>] = []) -> [TGameResult] {
            
        let fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sortDescriptors)
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch objects of type \(TGameResult.self): \(error)")
            return []
        }
    }
    
    private func fetchAllResults() -> [SDGameResult] {
        var allResults: [SDGameResult] = []
        allResults.append(contentsOf: fetchResults(for: SDStandardGameResult.self))
        allResults.append(contentsOf: fetchResults(for: SDRushGameResult.self))
        allResults.append(contentsOf: fetchResults(for: SDFrenzyGameResult.self))
        allResults.append(contentsOf: fetchResults(for: SDZenGameResult.self))
        allResults.append(contentsOf: fetchResults(for: SDDailyGameResult.self))
        allResults.append(contentsOf: fetchResults(for: SDQuadStandardGameResult.self))
        return allResults
    }
    
    // MARK: - Save Functions
    // Update database
    func saveGame(_ gameOverData : GameOverDataModel) {
        let model: any SDGameResult & PersistentModel
        
        switch gameOverData.gameMode {
        case .dailyGame:
            model = SDDailyGameResult(gameOverData)
        case .standardMode:
            model = SDStandardGameResult(gameOverData)
        case .rushMode:
            model  = SDRushGameResult(gameOverData)
        case .frenzyMode:
            model  = SDFrenzyGameResult(gameOverData)
        case .zenMode:
            model  = SDZenGameResult(gameOverData)
        case .quadWordMode:
            model  = SDQuadStandardGameResult(gameOverData)
        default:
            fatalError("Invalid game over data model")
        }
        
        context.insert(model)
        
        do {
            try context.save()
        } catch {
            fatalError("Could not save game")
        }
    }
}
