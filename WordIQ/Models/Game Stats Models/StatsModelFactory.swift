/// Factory for retrieving a stats model
class StatsModelFactory {
    
    private let databaseHelper: GameDatabaseClient
    
    init (databaseHelper: GameDatabaseClient) {
        self.databaseHelper = databaseHelper
    }
    
    func getStatsModel() -> StatsModel {
        return databaseHelper.getGameStatistics()
    }
    
    /// Gets the stats model for the given game mode
    func getStatsModel(for gameMode: GameMode) -> StatsModel {
        var model: StatsModel
        
        switch gameMode {
        case .dailyGame:
            model = databaseHelper.getGameStatistics(for: SDDailyGameResult.self)
            model.bestStreak = UserDefaultsClient.shared.maxStreak_daily
            model.currentStreak = UserDefaultsClient.shared.currentStreak_daily
        case .standardMode:
            model = databaseHelper.getGameStatistics(for: SDStandardGameResult.self)
            model.bestStreak = UserDefaultsClient.shared.maxStreak_standard
            model.currentStreak = UserDefaultsClient.shared.currentStreak_standard
        case .rushMode:
            model = databaseHelper.getGameStatistics(for: SDRushGameResult.self)
            model.bestStreak = UserDefaultsClient.shared.maxStreak_rush
            model.currentStreak = UserDefaultsClient.shared.currentStreak_rush
        case .frenzyMode:
            model = databaseHelper.getGameStatistics(for: SDFrenzyGameResult.self)
        case .zenMode:
            model = databaseHelper.getGameStatistics(for: SDZenGameResult.self)
        case .quadWordMode:
            model = databaseHelper.getGameStatistics(for: SDQuadStandardGameResult.self)
            model.bestStreak = UserDefaultsClient.shared.maxStreak_quadStandard
            model.currentStreak = UserDefaultsClient.shared.currentStreak_quadStandard
        default:
            fatalError("No StatsModel for \(gameMode)")
        }
        
        return model
    }
}
