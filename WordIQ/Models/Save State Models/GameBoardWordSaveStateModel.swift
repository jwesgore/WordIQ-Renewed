/// Save state for a game board word
struct GameBoardWordSaveStateModel : Codable {
    var letters: [GameBoardLetterSaveStateModel]
}
