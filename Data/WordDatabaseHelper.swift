import SQLite3
import Foundation

/// Wrapper to help interface with database file
class WordDatabaseHelper {
    
    static let shared = WordDatabaseHelper()
    
    let dailyEpoch: Date
    let tableName = "words_with_length_five"
    
    var db: OpaquePointer?
    
    /// Performs a query to get total number of rows
    var rowCount: Int {
        let queryStatementString = "SELECT COUNT(*) FROM \(tableName);"
        var queryStatement: OpaquePointer?
        var rowCount: Int = 0

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                rowCount = Int(sqlite3_column_int(queryStatement, 0))
            }
        }
        
        sqlite3_finalize(queryStatement)
        return rowCount
    }
    
    /// Initializer
    private init() {
        // Open Databse
        if let dbPath = Bundle.main.path(forResource: WordLists.database.filename, ofType: "db") {
            if sqlite3_open(dbPath, &db) == SQLITE_OK {
                print("Database opened successfully")
            } else {
                print("Uh oh spaghettios")
            }
        }
        
        // Setup daily epoch
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 3
        dateComponents.day = 9

        let calendar = Calendar.current
        if let epoch = calendar.date(from: dateComponents) {
            dailyEpoch = epoch
        } else {
            // Fallback to the current date if date creation fails
            dailyEpoch = Date()
        }
    }
    
    // MARK: Database fetch functions
    /// Get daily word automatically
    func fetchDailyWord() -> GameWordModel {
        let daysSinceEpoch = ValueConverter.daysSince(dailyEpoch)!
        return fetchDailyWord(dailyId: daysSinceEpoch)!
    }
    
    /// Perform a query to retrieve the daily word
    func fetchDailyWord(dailyId : Int) -> GameWordModel? {
        let queryStatementString = "SELECT word FROM \(tableName) WHERE daily = ?;"
        var queryStatement: OpaquePointer?
        
        let adjustedDailyId = dailyId % rowCount
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(adjustedDailyId))

            if sqlite3_step(queryStatement) == SQLITE_ROW {
                if let queryResultCol1 = sqlite3_column_text(queryStatement, 0) {
                    let dailyWord = String(cString: queryResultCol1)
                    sqlite3_finalize(queryStatement)
                    return GameWordModel(dailyWord)
                }
            }
        }
        
        return nil
    }
    
    /// Performs a query to retrieve a word at random
    func fetchRandomWord(withDifficulty level: GameDifficulty) -> GameWordModel {
        let queryStatementString = "SELECT word FROM \(tableName) WHERE difficulty >= ? ORDER BY RANDOM() LIMIT 1;"
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
        return GameWordModel(randomWord ?? "fault")
    }
    
    // MARK: Database helper functions
    /// Performs a query on the database to see if a word is valid
    func doesWordExist(_ word: GameWordModel) -> Bool {
        let queryStatementString = "SELECT 1 FROM \(tableName) WHERE word = ? COLLATE NOCASE LIMIT 1;"
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
    
    /// Prints all words stored in the database
    func printAllWords() {
        let queryStatementString = "SELECT word FROM \(tableName);"
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
    
    // MARK: Close Database
    /// Try to close the database
    func closeDatabase() {
        if sqlite3_close(db) == SQLITE_OK {
            print("Database closed successfully.")
        } else {
            print("Failed to close the database: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    /// Fallback for closing the database
    deinit {
        sqlite3_close(db)
    }
}
