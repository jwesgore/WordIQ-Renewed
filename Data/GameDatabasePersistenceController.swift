import Foundation
import CoreData

class GameDatabasePersistenceController {
    static let shared = GameDatabasePersistenceController()
    
    let container : NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: SystemNames.Data.gameDatabase)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    static var preview: GameDatabasePersistenceController = {
        let controller = GameDatabasePersistenceController(inMemory: true)
        // Create some sample data for the preview
        let viewContext = controller.container.viewContext
        for _ in 0..<10 {
            let newItem = GameResultsModel(context: viewContext)
            
            newItem.id = UUID()
            
            newItem.date = Date.now
            newItem.gameMode = Int64(GameMode.standardgame.id)
            newItem.gameDifficulty = Int64(GameDifficulty.normal.id)
            newItem.gameResult = Int64(GameResult.win.id)
            
            newItem.numCorrectWords = 1
            newItem.numValidGuesses = 10
            newItem.numInvalidGuesses = 3
            
            newItem.timeElapsed = 30
            newItem.timeLimit = 0
            newItem.targetWord = WordDatabaseHelper.shared.fetchRandomWord(withDifficulty: .normal).word
            newItem.xp = 0
        }
        for _ in 0..<5 {
            let newItem = GameResultsModel(context: viewContext)
            
            newItem.id = UUID()
            
            newItem.date = Date.now
            newItem.gameMode = Int64(GameMode.rushgame.id)
            newItem.gameDifficulty = Int64(GameDifficulty.normal.id)
            newItem.gameResult = Int64(GameResult.win.id)
            
            newItem.numCorrectWords = 1
            newItem.numValidGuesses = 5
            newItem.numInvalidGuesses = 1
            
            newItem.timeElapsed = 30
            newItem.timeLimit = 60
            newItem.targetWord = WordDatabaseHelper.shared.fetchRandomWord(withDifficulty: .normal).word
            newItem.xp = 0
        }
        for _ in 0..<5 {
            let newItem = GameResultsModel(context: viewContext)
            
            newItem.id = UUID()
            
            newItem.date = Date.now
            newItem.gameMode = Int64(GameMode.zengame.id)
            newItem.gameDifficulty = Int64(GameDifficulty.normal.id)
            newItem.gameResult = Int64(GameResult.win.id)
            
            newItem.numCorrectWords = 1
            newItem.numValidGuesses = 15
            newItem.numInvalidGuesses = 4
            
            newItem.timeElapsed = 30
            newItem.timeLimit = 0
            newItem.targetWord = WordDatabaseHelper.shared.fetchRandomWord(withDifficulty: .normal).word
            newItem.xp = 0
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return controller
    }()
    
}
