import SwiftUI

struct GameBoardSaveStateModel: Codable {
    let id: UUID
    let gameBoardPosition : Int
    let gameBoardWords: [GameBoardWordSaveStateModel]
    let targetWordHints : [ValidCharacters?]
}
