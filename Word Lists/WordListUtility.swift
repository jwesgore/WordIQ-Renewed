import Foundation

/// Class to assist with interacting with the word lists
class WordListUtility {
    
    static func GetWordListFromTextFile(_ wordList : WordLists) -> [GameWordModel] {
        var words = [GameWordModel]()
        
        if let fileUrl = Bundle.main.url(forResource: wordList.filename, withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileUrl) {
                for word in fileContents.components(separatedBy: "\n") {
                    words.append(GameWordModel(word.uppercased()))
                }
            }
        }
        
        return words
    }
    
}

/// Enum for storing file names
enum WordLists {
    case all, easy, normal, hard
    case database
    
    var filename : String {
        switch self {
        case .all: return "five_letter_words"
        case .easy: return "five_letter_words_easy"
        case .normal: return "five_letter_words_normal"
        case .hard: return "five_letter_words_hard"
        case .database: return "WordIQDatabase"
        }
    }
}
