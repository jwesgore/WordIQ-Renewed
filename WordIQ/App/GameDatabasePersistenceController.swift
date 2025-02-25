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
}
