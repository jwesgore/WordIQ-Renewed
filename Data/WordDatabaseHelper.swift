import SQLite3
import Foundation

/// Wrapper to help interface with database file
class WordDatabaseHelper {
    static let shared = WordDatabaseHelper()
    
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
            sqlite3_bind_int(queryStatement, 1, Int32(level.id))
            
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
    
    /// Prints all words stored in the database
    func printAllWords() {
        let queryStatementString = "SELECT word FROM words;"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if let queryResultCol1 = sqlite3_column_text(queryStatement, 0) {
                    let word = String(cString: queryResultCol1)
                    print("Word: \(word)")
                }
            }
        } else {
            print("SELECT statement could not be prepared: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(queryStatement)
    }

    /// Performs a query on the database to see if a word is valid
    func doesWordExist(_ word: GameWordModel) -> Bool {
        let queryStatementString = "SELECT 1 FROM words WHERE word = ? COLLATE NOCASE LIMIT 1;"
        var queryStatement: OpaquePointer?
        var exists = false

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // Bind the text value using NSString's utf8String
            sqlite3_bind_text(queryStatement, 1, (word.word as NSString).utf8String, -1, nil)

            if sqlite3_step(queryStatement) == SQLITE_ROW {
                exists = true
            }
        } else {
            print("SELECT statement could not be prepared: \(String(cString: sqlite3_errmsg(db)))")
        }

        sqlite3_finalize(queryStatement)
        return exists
    }

    deinit {
        sqlite3_close(db)
    }
}
