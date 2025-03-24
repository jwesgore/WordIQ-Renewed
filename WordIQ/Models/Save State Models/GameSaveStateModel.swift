/// Struct for saving game state
struct GameSaveStateModel : Codable {
    let clockState : ClockSaveStateModel
    let gameBoard: GameBoardSaveStateModel
    let gameOptionsModel : SingleWordGameModeOptionsModel
    let gameOverModel : SingleWordGameOverDataModel
    let keyboardLetters : [ValidCharacters : LetterComparison]
}
