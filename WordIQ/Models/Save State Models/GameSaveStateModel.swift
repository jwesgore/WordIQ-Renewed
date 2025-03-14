/// Struct for saving game state
struct GameSaveStateModel : Codable {
    let boardPosition : Int
    let clockState : ClockSaveStateModel
    let gameBoardWords : [GameBoardWordSaveStateModel]
    let gameOptionsModel : GameModeOptionsModel
    let gameOverModel : GameOverDataModel
    let keyboardLetters : [ValidCharacters : LetterComparison]
    let targetWordHints : [ValidCharacters?]
}
