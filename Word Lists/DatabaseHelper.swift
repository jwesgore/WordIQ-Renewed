import SQLite3
import Foundation

/// Wrapper to help interface with database file
class DatabaseHelper {
    static let shared = DatabaseHelper()
    
    var db: OpaquePointer?
    
    private init() {
        if let dbPath = Bundle.main.path(forResource: WordLists.database.filename, ofType: "db") {
            if sqlite3_open(dbPath, &db) == SQLITE_OK {
                print("Database opened successfully")
            } else {
                print("Uh oh spaghettios")
            }
        }
    }
    
    /// Performs a query to retrieve a word at random
    func fetchRandomWord(withDifficulty level: GameDifficulty) -> GameWordModel {
        let queryStatementString = "SELECT word FROM words WHERE difficulty >= ? ORDER BY RANDOM() LIMIT 1;"
        var queryStatement: OpaquePointer?
        var randomWord: String?

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(level.asInt))
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                if let queryResultCol1 = sqlite3_column_text(queryStatement, 0) {
                    randomWord = String(cString: queryResultCol1)
                }
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return GameWordModel(randomWord!)
    }
    
    /// Performs a query on the database to see if a word is valid
    func doesWordExist(_ word: GameWordModel) -> Bool {
        let queryStatementString = "SELECT 1 FROM words WHERE LOWER(word) = LOWER(?) LIMIT 1;"
        var queryStatement: OpaquePointer?
        var exists = false

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, word.word.lowercased(), -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                exists = true
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return exists
    }
    
    deinit {
        sqlite3_close(db)
    }
}
