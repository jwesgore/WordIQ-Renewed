import SwiftUI

/// Struct for passing around words from database
struct DatabaseWordModel : Codable, Equatable, Hashable {
    
    let daily : Int
    let difficulty : GameDifficulty
    let word : String
    
    /// Equatable Conformance
    static func == (lhs: DatabaseWordModel, rhs: DatabaseWordModel) -> Bool {
        return lhs.word == rhs.word
    }
}

/// Extra initializers
extension DatabaseWordModel {
    /// Initializer to assist with loading from Word Database
    init(daily: Int, difficulty: Int, word: String) {
        self.daily = daily
        self.difficulty = GameDifficulty.fromId(difficulty)!
        self.word = word
    }
    
    /// Initializer to assist with reading from Core Data database
    init(daily: Int64, difficulty: Int64, word: String?) {
        self.daily = Int(daily)
        self.difficulty = GameDifficulty.fromId(Int(difficulty))!
        self.word = word!
    }
}
