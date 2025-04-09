/// Factory for retrieving a stats model
class StatsModelFactory {
    
    private let databaseHelper: GameDatabaseHelper
    
    init (databaseHelper: GameDatabaseHelper) {
        self.databaseHelper = databaseHelper
    }
    
    /// Gets the stats model for the given game mode
    func getStatsModel(for gameMode: GameMode) -> StatsModel {
        var model: StatsModel
        
        switch gameMode {
        case .dailyGame:
            model = databaseHelper.getGameStatistics(for: CDDailyModeGameResult.self)
            model.bestStreak = UserDefaultsHelper.shared.maxStreak_daily
            model.currentStreak = UserDefaultsHelper.shared.currentStreak_daily
        case .standardMode:
            model = databaseHelper.getGameStatistics(for: CDStandardModeGameResult.self)
            model.bestStreak = UserDefaultsHelper.shared.maxStreak_standard
            model.currentStreak = UserDefaultsHelper.shared.currentStreak_standard
        case .rushMode:
            model = databaseHelper.getGameStatistics(for: CDRushModeGameResult.self)
            model.bestStreak = UserDefaultsHelper.shared.maxStreak_rush
            model.currentStreak = UserDefaultsHelper.shared.currentStreak_rush
        case .frenzyMode:
            model = databaseHelper.getGameStatistics(for: CDFrenzyModeGameResult.self)
        case .zenMode:
            model = databaseHelper.getGameStatistics(for: CDZenModeGameResult.self)
        case .quadWordMode:
            model = databaseHelper.getGameStatistics(for: CDQuadStandardGameResult.self)
        default:
            fatalError("No StatsModel for \(gameMode)")
        }
        
        return model
    }
}
