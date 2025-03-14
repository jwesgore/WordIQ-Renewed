/// Struct for preserving GameBoardLetterViewModel state
struct GameBoardLetterSaveStateModel : Codable {
    var letter : ValidCharacters
    var letterComparison : LetterComparison
}
