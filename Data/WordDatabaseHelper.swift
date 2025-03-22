import SQLite3
import Foundation

/// Wrapper to help interface with database file
class WordDatabaseHelper {
    
    static let shared = WordDatabaseHelper()
    
    let dailyEpoch: Date
    
    var db: OpaquePointer?

    /// Initializer
    private init() {
        // Open Database
        guard let dbPath = Bundle.main.path(forResource: WordDatabaseEnum.databaseName.rawValue, ofType: "db") else {
            fatalError("Database file not found")
        }
        
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            fatalError("Failed to open database")
        }
        
        print("Database opened successfully")
        
        // Setup daily epoch
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 3
        dateComponents.day = 9

        let calendar = Calendar.current
        guard let epochDate = calendar.date(from: dateComponents) else {
            fatalError("Could not create epoch date")
        }
        
        self.dailyEpoch = epochDate
    }
    
    // MARK: Database fetch functions
    /// Get daily word automatically
    func fetchDailyFiveLetterWord() -> DatabaseWordModel {
        guard let daysSinceEpoch = ValueConverter.daysSince(dailyEpoch), daysSinceEpoch > 0 else {
            fatalError("Unable to fetch days since epoch")
        }
        guard let dailyWord = fetchDailyFiveLetterWord(dailyId: daysSinceEpoch) else {
            fatalError("Unable to fetch daily word")
        }
        return dailyWord
    }
    
    /// Perform a query to retrieve the daily word
    func fetchDailyFiveLetterWord(dailyId: Int) -> DatabaseWordModel? {
        let queryStatementString = "SELECT daily, difficulty, word FROM \(WordDatabaseEnum.fiveLetterTableName.rawValue) WHERE daily = ?;"
        var queryStatement: OpaquePointer?
        
        let adjustedDailyId = dailyId % fetchTableRowCount(WordDatabaseEnum.fiveLetterTableName)
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(adjustedDailyId))

            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let daily = Int(sqlite3_column_int(queryStatement, 0))
                let difficulty = Int(sqlite3_column_int(queryStatement, 1))
                
                if let queryResultCol3 = sqlite3_column_text(queryStatement, 2) {
                    let word = String(cString: queryResultCol3)
                    sqlite3_finalize(queryStatement)
                    
                    let databaseWord = DatabaseWordModel(daily: daily, difficulty: difficulty, word: word)
                    return databaseWord
                }
            }
            sqlite3_finalize(queryStatement)
        }
        
        return nil
    }

    /// Fetches a random word from the database based on the difficulty level
    func fetchRandomFiveLetterWord(withDifficulty level: GameDifficulty) -> DatabaseWordModel {
        let queryStatementString = "SELECT daily, difficulty, word FROM \(WordDatabaseEnum.fiveLetterTableName.rawValue) WHERE difficulty >= ? ORDER BY RANDOM() LIMIT 1;"
        var queryStatement: OpaquePointer?

        guard sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK else {
            fatalError("SELECT statement could not be prepared")
        }
        
        sqlite3_bind_int(queryStatement, 1, Int32(level.id))
        
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            fatalError("No word found for the given difficulty")
        }
        
        let daily = Int(sqlite3_column_int(queryStatement, 0))
        let difficulty = Int(sqlite3_column_int(queryStatement, 1))
        
        guard let queryResultCol3 = sqlite3_column_text(queryStatement, 2) else {
            fatalError("Failed to retrieve word from the database")
        }
        
        let word = String(cString: queryResultCol3)
        sqlite3_finalize(queryStatement)

        let databaseWord = DatabaseWordModel(daily: daily, difficulty: difficulty, word: word)
        return databaseWord
    }
    
    func fetchMultipleRandomFiveLetterWord(withDifficulty level: GameDifficulty, count: Int) -> [DatabaseWordModel] {
        let queryStatementString = "SELECT daily, difficulty, word FROM \(WordDatabaseEnum.fiveLetterTableName.rawValue) WHERE difficulty >= ? ORDER BY RANDOM() LIMIT \(count);"
        
        var queryStatement: OpaquePointer?
        var words: [DatabaseWordModel] = []

        guard sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK else {
            fatalError("SELECT statement could not be prepared")
        }
        
        sqlite3_bind_int(queryStatement, 1, Int32(level.id))
        
        // Loop through all rows
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            let daily = Int(sqlite3_column_int(queryStatement, 0))
            let difficulty = Int(sqlite3_column_int(queryStatement, 1))
            
            guard let queryResultCol3 = sqlite3_column_text(queryStatement, 2) else {
                fatalError("Failed to retrieve word from the database")
            }
            
            let word = String(cString: queryResultCol3)
            
            let databaseWord = DatabaseWordModel(daily: daily, difficulty: difficulty, word: word)
            words.append(databaseWord)
        }
        
        sqlite3_finalize(queryStatement)
        return words
    }
    
    /// Performs a query to get total number of rows
    func fetchTableRowCount(_ table : WordDatabaseEnum) -> Int {
        let queryStatementString = "SELECT COUNT(*) FROM \(table.rawValue);"
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
    
    // MARK: Database helper functions
    /// Performs a query on the database to see if a word is valid
    func doesFiveLetterWordExist(_ word: GameWordModel) -> Bool {
        let queryStatementString = "SELECT 1 FROM \(WordDatabaseEnum.fiveLetterTableName.rawValue) WHERE word = ? COLLATE NOCASE LIMIT 1;"
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
    func printAllFiveLetterWords() {
        let queryStatementString = "SELECT word FROM \(WordDatabaseEnum.fiveLetterTableName.rawValue);"
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
