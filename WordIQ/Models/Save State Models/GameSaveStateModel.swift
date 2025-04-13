/// Struct for saving game state
struct GameSaveStateModel : Codable {
    let clockState : ClockSaveStateModel
    let gameBoard: GameBoardSaveStateModel
    let gameOptionsModel : SingleWordGameOptionsModel
    let gameOverModel : GameOverDataModel
    let keyboardLetters : [ValidCharacters : LetterComparison]
}
